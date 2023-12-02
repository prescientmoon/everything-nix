# TODO(imperanence): handle persistence of things like harpoon, lazy, etc
{ pkgs, lib, config, inputs, ... }:
let
  # {{{ extraPackages
  extraPackages = with pkgs; [
    # Language servers
    nodePackages.typescript-language-server # typescript
    nodePackages_latest.purescript-language-server # purescript
    lua-language-server # lua
    rnix-lsp # nix
    nil # nix
    inputs.nixd.packages.${system}.nixd # nix
    haskell-language-server # haskell
    # REASON: marked as broken
    # dhall-lsp-server # dhall
    tectonic # something related to latex (?)
    texlab # latex
    nodePackages_latest.vscode-langservers-extracted # web stuff
    python310Packages.python-lsp-server # python
    pyright # python
    rust-analyzer # rust
    typst-lsp # typst

    # Formatters
    luaformatter # Lua
    stylua # Lua
    black # Python
    yapf # Python
    isort # Reorder python imports
    nodePackages_latest.purs-tidy # Purescript
    nodePackages_latest.prettier # Js & friends
    nodePackages_latest.prettier_d_slim # Js & friends
    typst-fmt # Typst

    # Linters
    ruff # Python linter
    mypy # Python typechecking

    # Languages
    nodePackages.typescript # typescript
    lua # For repls and whatnot
    wakatime # time tracking
    rustfmt

    # Others
    fd # file finder
    ripgrep # Grep rewrite
    update-nix-fetchgit # Useful for nix stuff
    tree-sitter # Syntax highlighting
    libstdcxx5 # Required by treesitter aparently
    python310Packages.jupytext # Convert between jupyter notebooks and python files
    graphviz # For rust crate graph
    haskellPackages.hoogle # For haskell search

    # Preview
    zathura # Pdf reader
    xdotool # For zathura reverse search or whatever it's called
    glow # Md preview in terminal
    pandoc # Md processing
    libsForQt5.falkon # Needed for one of the md preview plugins I tried

    # Latex setup
    texlive.combined.scheme-full # Latex stuff
    python38Packages.pygments # required for latex syntax highlighting
    sage
    sagetex # sage in latex

    # required for the telescope fzf extension
    gnumake
    cmake
    gcc

    # Required by magma-nvim:
    # python310Packages.pynvim
    # python310Packages.jupyter
  ];
  # }}}
  # {{{ extraRuntime
  extraRuntimePaths = env: [
    # Base16 theme
    (pkgs.writeTextDir
      "lua/nix/theme.lua"
      config.satellite.colorscheme.lua
    )

    # Provide hints as to what app we are in
    # (Useful because neovide does not provide the info itself right away)
    (pkgs.writeTextDir
      "lua/nix/env.lua"
      "return '${env}'"
    )

    # Experimental nix module generation
    config.satellite.neovim.generated.all
  ];

  extraRuntime = env:
    let
      generated = pkgs.symlinkJoin {
        name = "nixified-neovim-lua-modules";
        paths = extraRuntimePaths env;
      };

      snippets = config.satellite.dev.path "home/features/neovim/snippets";
    in
    lib.concatStringsSep "," [ generated snippets ];
  # }}}
  # {{{ Client wrapper
  # Wraps a neovim client, providing the dependencies
  # and setting some flags:
  #
  # - NVIM_EXTRA_RUNTIME provides extra directories to add to the runtimepath. 
  #   I cannot just install those dirs using the builtin package support because 
  #   my package manager (lazy.nvim) disables those.
  wrapClient = { base, name, binName ? name, extraArgs ? "" }:
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${binName} \
          --prefix PATH : ${lib.makeBinPath extraPackages} \
          --set NVIM_EXTRA_RUNTIME ${extraRuntime name} \
          ${extraArgs}
      '';
    };
  # }}}
  # {{{ Clients
  neovim = wrapClient {
    base = pkgs.neovim;
    name = "nvim";
  };

  neovide = wrapClient {
    base = pkgs.neovide;
    name = "neovide";
    extraArgs = "--set NEOVIDE_MULTIGRID true";
  };

  firenvim = wrapClient {
    base = pkgs.neovim;
    name = "firenvim";
    binName = "nvim";
    extraArgs = "--set GIT_DISCOVERY_ACROSS_FILESYSTEM 1";
  };
  # }}}

  nlib = config.satellite.neovim.lib;
in
{
  # {{{ Basic config
  # We still want other modules to know that we are using neovim!
  satellite.toggles.neovim.enable = true;

  xdg.configFile.nvim.source = config.satellite.dev.path "home/features/neovim/config";
  home.sessionVariables.EDITOR = "nvim";

  home.packages = [
    neovim
    neovide
    pkgs.vimclip
  ];
  # }}}
  # {{{ Firenvim
  home.file.".mozilla/native-messaging-hosts/firenvim.json" =
    lib.mkIf config.programs.firefox.enable {
      text =
        let
          # God knows what this does
          # https://github.com/glacambre/firenvim/blob/87c9f70d3e6aa2790982aafef3c696dbe962d35b/autoload/firenvim.vim#L592
          firenvim_init = pkgs.writeText "firenvim_init.vim" ''
            let g:firenvim_i=[]
            let g:firenvim_o=[]
            let g:Firenvim_oi={i,d,e->add(g:firenvim_i,d)}
            let g:Firenvim_oo={t->[chansend(2,t)]+add(g:firenvim_o,t)}
            let g:firenvim_c=stdioopen({'on_stdin':{i,d,e->g:Firenvim_oi(i,d,e)},'on_print':{t->g:Firenvim_oo(t)}})
            let g:started_by_firenvim = v:true
          '';

          firenvim_file_loaded = pkgs.writeText "firenvim_file_loaded.vim" ''
            try
              call firenvim#run()
            catch /Unknown function/
              call chansend(g:firenvim_c,["f\n\n\n"..json_encode({"messages":["Your plugin manager did not load the Firenvim plugin for neovim."],"version":"0.0.0"})])
              call chansend(2,["Firenvim not in runtime path. &rtp="..&rtp])
              qall!
            catch
              call chansend(g:firenvim_c,["l\n\n\n"..json_encode({"messages": ["Something went wrong when running firenvim. See troubleshooting guide."],"version":"0.0.0"})])
              call chansend(2,[v:exception])
              qall!
            endtry
          '';
        in
        builtins.toJSON {
          name = "firenvim";
          description = "Turn your browser into a Neovim GUI.";
          type = "stdio";
          allowed_extensions = [ "firenvim@lacamb.re" ];
          path = pkgs.writeShellScript "firenvim.sh" ''
            mkdir -p /run/user/$UID/firenvim
            chmod 700 /run/user/$UID/firenvim
            cd /run/user/$UID/firenvim

            exec '${firenvim}/bin/nvim' --headless \
              --cmd 'source "${firenvim_init}"' \
              -S    '${firenvim_file_loaded}'
          '';
        };
    };
  # }}}
  # {{{ Custom module testing 
  satellite.neovim.styluaConfig = ../../../stylua.toml;
  satellite.neovim.env.module = "my.helpers.env";

  # {{{ Nvim-tree 
  satellite.neovim.lazy.nvim-tree = {
    package = "kyazdani42/nvim-tree.lua";
    setup = true;
    keys.mapping = "<C-n>";
    keys.desc = "Toggle [n]vim-tree";
    keys.action = "<cmd>NvimTreeToggle<cr>";
    cond = nlib.blacklistEnv [ "vscode" "firenvim" ];
  };
  # }}}
  # {{{ Lualine
  satellite.neovim.lazy.lualine = {
    package = "nvim-lualine/lualine.nvim";
    name = "lualine";

    cond = nlib.blacklistEnv [ "vscode" "firenvim" ];
    event = "VeryLazy";

    opts = {
      options = {
        component_separators = { left = ""; right = ""; };
        section_separators = { left = ""; right = ""; };
        theme = "auto";
        disabled_filetypes = [ "undotree" ];
      };

      sections = {
        lualine_a = [ "branch" ];
        lualine_b = [ "filename" ];
        lualine_c = [ "filetype" ];
        lualine_x = [ "diagnostics" "diff" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };

      # Integration with other plugins
      extensions = [ "nvim-tree" ];
    };
  };
  # }}}
  # {{{ Winbar
  satellite.neovim.lazy.winbar = {
    package = "fgheng/winbar.nvim";
    name = "winbar";

    cond = nlib.blacklistEnv [ "vscode" "firenvim" ];
    event = "VeryLazy";

    opts.enabled = true;
  };
  # }}}
  # {{{ Flash
  satellite.neovim.lazy.flash = {
    package = "folke/flash.nvim";
    name = "flash";

    cond = nlib.blacklistEnv [ "vscode" "firenvim" ];
    keys =
      let keybind = mode: mapping: action: desc: {
        inherit mapping desc mode;
        action = nlib.lua ''function () require("flash").${action}() end'';
      };
      in
      [
        (keybind "nxo" "s" "jump" "Flash")
        (keybind "nxo" "S" "treesitter" "Flash Treesitter")
        (keybind "o" "r" "remote" "Remote Flash")
        (keybind "ox" "R" "treesitter_search" "Treesitter Search")
        (keybind "c" "<C-S>" "toggle" "Toggle Flash Search")
      ];

    # Disable stuff like f/t/F/T
    opts.modes.char.enabled = false;
  };
  # }}}
  # }}}
}
