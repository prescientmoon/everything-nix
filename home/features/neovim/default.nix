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
    # haskell-language-server # haskell
    # REASON: marked as broken
    # dhall-lsp-server # dhall
    # tectonic # something related to latex (?)
    texlab # latex
    nodePackages_latest.vscode-langservers-extracted # web stuff
    # python310Packages.python-lsp-server # python
    # pyright # python
    rust-analyzer # rust
    typst-lsp # typst

    # Formatters
    # luaformatter # Lua
    stylua # Lua
    # black # Python
    # yapf # Python
    # isort # Reorder python imports
    nodePackages_latest.purs-tidy # Purescript
    nodePackages_latest.prettier # Js & friends
    nodePackages_latest.prettier_d_slim # Js & friends
    typst-fmt # Typst

    # Linters
    ruff # Python linter
    # mypy # Python typechecking

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
    # python310Packages.jupytext # Convert between jupyter notebooks and python files
    # graphviz # For rust crate graph
    haskellPackages.hoogle # For haskell search

    # Preview
    # zathura # Pdf reader
    # xdotool # For zathura reverse search or whatever it's called
    # glow # Md preview in terminal
    # pandoc # Md processing
    # libsForQt5.falkon # Needed for one of the md preview plugins I tried

    # Latex setup
    # texlive.combined.scheme-full # Latex stuff
    # python38Packages.pygments # required for latex syntax highlighting
    # sage
    # sagetex # sage in latex

    # required for the telescope fzf extension
    gnumake
    cmake
    gcc

    # Required by magma-nvim:
    # python310Packages.pynvim
    # python310Packages.jupyter
  ] ++ config.satellite.neovim.generated.dependencies;
  # }}}
  # {{{ extraRuntime
  extraRuntimePaths = env: [
    # Base16 theme
    (config.satellite.lib.lua.writeFile
      "lua/nix" "theme"
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
    base =
      if config.satellite.toggles.neovim-nightly.enable
      then pkgs.neovim-nightly
      else pkgs.neovim;
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
  lazy = config.satellite.neovim.lazy;
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
          firenvim_init = pkgs.writeText "firenvim_init.vim" /* vim */ ''
            let g:firenvim_i=[]
            let g:firenvim_o=[]
            let g:Firenvim_oi={i,d,e->add(g:firenvim_i,d)}
            let g:Firenvim_oo={t->[chansend(2,t)]+add(g:firenvim_o,t)}
            let g:firenvim_c=stdioopen({'on_stdin':{i,d,e->g:Firenvim_oi(i,d,e)},'on_print':{t->g:Firenvim_oo(t)}})
            let g:started_by_firenvim = v:true
          '';

          firenvim_file_loaded = pkgs.writeText "firenvim_file_loaded.vim" /* vim */ ''
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
  # {{{ Plugins
  satellite.lua.styluaConfig = ../../../stylua.toml;
  satellite.neovim.runtime = {
    env = "my.helpers.env";
    languageServerOnAttach = "my.plugins.lspconfig";
    tempest = "my.runtime";
  };

  # {{{ libraries
  # {{{ plenary
  satellite.neovim.lazy.plenary = {
    package = "nvim-lua/plenary.nvim";
    # Autoload when running tests
    cmd = [ "PlenaryBustedDirectory" "PlenaryBustedFile" ];
  };
  # }}}
  # {{{ nui
  satellite.neovim.lazy.nui.package = "MunifTanjim/nui.nvim";
  # }}}
  # {{{ web-devicons
  satellite.neovim.lazy.web-devicons.package = "nvim-tree/nvim-web-devicons";
  # }}}
  # }}}
  # {{{ ui
  # {{{ nvim-tree 
  satellite.neovim.lazy.nvim-tree = {
    package = "kyazdani42/nvim-tree.lua";

    env.blacklist = [ "vscode" "firenvim" ];
    setup = true;

    keys.mapping = "<C-n>";
    keys.desc = "Toggle [n]vim-tree";
    keys.action = "<cmd>NvimTreeToggle<cr>";
  };
  # }}}
  # {{{ lualine
  satellite.neovim.lazy.lualine = {
    package = "nvim-lualine/lualine.nvim";
    dependencies.lua = [ lazy.web-devicons.package ];

    env.blacklist = [ "vscode" "firenvim" ];
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
  # {{{ winbar
  satellite.neovim.lazy.winbar = {
    package = "fgheng/winbar.nvim";

    env.blacklist = [ "vscode" "firenvim" ];
    event = "VeryLazy";

    opts.enabled = true;
  };
  # }}}
  # {{{ harpoon
  satellite.neovim.lazy.harpoon = {
    package = "ThePrimeagen/harpoon";
    keys =
      let goto = key: index: {
        desc = "Goto harpoon file ${toString index}";
        mapping = "<c-s>${key}";
        action = nlib.thunk
          /* lua */ ''require("harpoon.ui").nav_file(${toString index})'';
      };
      in
      [
        {
          desc = "Add file to [h]arpoon";
          mapping = "<leader>H";
          action = nlib.thunk
            /* lua */ ''require("harpoon.mark").add_file()'';
        }
        {
          desc = "Toggle harpoon quickmenu";
          mapping = "<c-a>";
          action = nlib.thunk
            /* lua */ ''require("harpoon.ui").toggle_quick_menu()'';
        }
        (goto "q" 1)
        (goto "w" 2)
        (goto "e" 3)
        (goto "r" 4)
        (goto "a" 5)
        (goto "s" 6)
        (goto "d" 7)
        (goto "f" 8)
        (goto "z" 9)
      ];
  };
  # }}}
  # }}}
  # {{{ visual
  # The line between `ui` and `visual is a bit rought. I currenlty mostly judge
  # it by vibe.
  # {{{ indent-blankline 
  satellite.neovim.lazy.indent-blankline = {
    package = "lukas-reineke/indent-blankline.nvim";
    main = "ibl";
    setup = true;

    env.blacklist = [ "vscode" ];
    event = "BufReadPost";
  };
  # }}}
  # }}}
  # {{{ editing
  # {{{ text navigation
  # {{{ flash
  satellite.neovim.lazy.flash = {
    package = "folke/flash.nvim";

    env.blacklist = [ "vscode" ];
    keys =
      let keybind = mode: mapping: action: desc: {
        inherit mapping desc mode;
        action = nlib.thunk /* lua */ ''require("flash").${action}()'';
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
  # {{{ ftft (quickscope but written in lua)
  satellite.neovim.lazy.ftft = {
    package = "gukz/ftFT.nvim";

    env.blacklist = [ "vscode" ];
    keys = [ "f" "F" "t" "T" ];
    setup = true;
  };
  # }}}
  # }}}
  # {{{ clipboard-image
  satellite.neovim.lazy.clipboard-image = {
    package = "postfen/clipboard-image.nvim";

    env.blacklist = [ "firenvim" ];
    cmd = "PasteImg";

    keys = {
      mapping = "<leader>p";
      action = "<cmd>PasteImg<cr>";
      desc = "[P]aste image from clipboard";
    };

    opts.default.img_name = nlib.import ./plugins/clipboard-image.lua "img_name";
    opts.tex = {
      img_dir = [ "%:p:h" "img" ];
      affix = "\\includegraphics[width=\\textwidth]{%s}";
    };
    opts.typst = {
      img_dir = [ "%:p:h" "img" ];
      affix = ''#image("%s", width: 100)'';
    };
  };
  # }}}
  # {{{ lastplace 
  satellite.neovim.lazy.lastplace = {
    package = "ethanholz/nvim-lastplace";

    env.blacklist = [ "vscode" ];
    event = "BufReadPre";

    opts.lastplace_ignore_buftype = [ "quickfix" "nofile" "help" ];
  };
  # }}}
  # {{{ undotree
  satellite.neovim.lazy.undotree = {
    package = "mbbill/undotree";

    env.blacklist = [ "vscode" ];
    cmd = "UndotreeToggle";
    keys = {
      mapping = "<leader>u";
      action = "<cmd>UndoTreeToggle<cr>";
      desc = "[U]ndo tree";
    };
  };
  # }}}
  # {{{ ssr (structured search & replace)
  satellite.neovim.lazy.ssr = {
    package = "cshuaimin/ssr.nvim";

    env.blacklist = [ "vscode" ];
    keys = {
      mode = "nx";
      mapping = "<leader>rt";
      action = nlib.thunk /* lua */ ''require("ssr").open()'';
      desc = "[r]eplace [t]emplate";
    };

    opts.keymaps.replace_all = "<s-cr>";
  };
  # }}}
  # {{{ edit-code-block (edit injections in separate buffers)
  satellite.neovim.lazy.edit-code-block = {
    package = "dawsers/edit-code-block.nvim";
    dependencies.lua = [ "nvim-treesitter/nvim-treesitter" ];
    main = "ecb";

    env.blacklist = [ "vscode" ];
    setup = true;
    keys = {
      mapping = "<leader>e";
      action = "<cmd>EditCodeBlock<cr>";
      desc = "[e]dit injection";
    };
  };
  # }}}
  # {{{ mini.comment 
  satellite.neovim.lazy.mini-comment = {
    package = "echasnovski/mini.comment";
    name = "mini.comment";

    setup = true;
    keys = [
      { mapping = "gc"; mode = "nxv"; }
      { mapping = "gcc"; }
    ];
  };
  # }}}
  # }}}
  # {{{ ide
  # {{{ conform
  satellite.neovim.lazy.conform = {
    package = "stevearc/conform.nvim";

    env.blacklist = [ "vscode" ];
    event = "BufReadPost";

    opts.format_on_save.lsp_fallback = true;
    opts.formatters_by_ft = let prettier = [ [ "prettierd" "prettier" ] ]; in
      {
        lua = [ "stylua" ];
        python = [ "ruff_format" ];

        javascript = prettier;
        typescript = prettier;
        javascriptreact = prettier;
        typescriptreact = prettier;
        html = prettier;
        css = prettier;
        markdown = prettier;
      };
  };
  # }}}
  # {{{ neoconf
  satellite.neovim.lazy.neoconf = {
    package = "folke/neoconf.nvim";

    cmd = "Neoconf";

    opts.import = {
      vscode = true; # local .vscode/settings.json
      coc = false; # global/local coc-settings.json
      nlsp = false; # global/local nlsp-settings.nvim json settings
    };
  };
  # }}}
  # }}}
  # {{{ language support 
  # {{{ haskell
  satellite.neovim.lazy.haskell-tools = {
    package = "mrcjkb/haskell-tools.nvim";
    dependencies.lua = [ lazy.plenary.package ];
    version = "^2";

    env.blacklist = [ "vscode" ];
    ft = [ "haskell" "lhaskell" "cabal" "cabalproject" ];

    setup.vim.g.haskell_tools = {
      hls = {
        on_attach = nlib.lua /* lua */ ''require("my.plugins.lspconfig").on_attach'';
        settings.haskell = {
          formattingProvider = "fourmolu";

          # This seems to work better with custom preludes
          # See this issue https://github.com/fourmolu/fourmolu/issues/357
          plugin.fourmolu.config.external = true;
        };
      };

      # I think this wasn't showing certain docs as I expected (?)
      tools.hover.enable = false;
    };
  };
  # }}}
  # {{{ rust 
  # {{{ rust-tools 
  satellite.neovim.lazy.rust-tools = {
    package = "simrat39/rust-tools.nvim";

    env.blacklist = [ "vscode" ];
    ft = "rust";

    opts.server.on_attach = nlib.languageServerOnAttach {
      keys = {
        mapping = "<leader>lc";
        action = "<cmd>RustOpenCargo<cr>";
        desc = "Open [c]argo.toml";
      };
    };
  };
  # }}}
  # {{{ crates 
  satellite.neovim.lazy.crates = {
    package = "saecki/crates.nvim";
    dependencies.lua = [ lazy.plenary.package ];

    env.blacklist = [ "vscode" ];
    event = "BufReadPost Cargo.toml";

    # {{{ Set up null_ls source
    opts.null_ls = {
      enabled = true;
      name = "crates";
    };
    # }}}

    setup.autocmds = [
      # {{{ Load cmp source on insert 
      {
        event = "InsertEnter";
        group = "CargoCmpSource";
        pattern = "Cargo.toml";
        callback = nlib.thunkString /* lua */ ''
          require("cmp").setup.buffer({ sources = { { name = "crates" } } })
        '';
      }
      # }}}
      # {{{ Load keybinds on attach
      {
        event = "BufReadPost";
        group = "CargoKeybinds";
        pattern = "Cargo.toml";
        # {{{ Register which-key info
        callback.callback = nlib.contextThunk /* lua */ ''
          require("which-key").register({
            ["<leader>lc"] = {
              name = "[l]ocal [c]rates",
              bufnr = context.bufnr
            },
          })
        '';
        # }}}

        callback.keys =
          let
            # {{{ Keymap helpers 
            keymap = mapping: action: desc: {
              inherit mapping desc;
              action = nlib.lua /* lua */ ''require("crates").${action}'';
            };

            keyroot = "<leader>lc";
            # }}}
          in
          # {{{ Keybinds
          [
            (keymap "${keyroot}t" "toggle" "[c]rates [t]oggle")
            (keymap "${keyroot}r" "reload" "[c]rates [r]efresh")

            (keymap "${keyroot}H" "open_homepage" "[c]rate [H]omephage")
            (keymap "${keyroot}R" "open_repository" "[c]rate [R]epository")
            (keymap "${keyroot}D" "open_documentation" "[c]rate [D]ocumentation")
            (keymap "${keyroot}C" "open_crates_io" "[c]rate [C]rates.io")

            (keymap "${keyroot}v" "show_versions_popup" "[c]rate [v]ersions")
            (keymap "${keyroot}f" "show_features_popup" "[c]rate [f]eatures")
            (keymap "${keyroot}d" "show_dependencies_popup" "[c]rate [d]eps")
            (keymap "K" "show_popup" "[c]rate popup")
          ];
        # }}}
      }
      # }}}
    ];
  };
  # }}}
  # }}}
  # }}}
  # {{{ external
  # These plugins integrate neovim with external services
  # {{{ wakatime
  satellite.neovim.lazy.wakatime = {
    package = "wakatime/vim-wakatime";
    env.blacklist = [ "vscode" "firenvim" ];
    event = "VeryLazy";
  };
  # }}}
  # {{{ discord rich presence 
  satellite.neovim.lazy.discord-rich-presence = {
    package = "andweeb/presence.nvim";
    main = "presence";

    env.blacklist = [ "vscode" "firenvim" ];
    event = "VeryLazy";
    setup = true;
  };
  # }}}
  # {{{ gitlinker 
  # generate permalinks for code
  satellite.neovim.lazy.gitlinker =
    let mapping = "<leader>yg";
    in
    {
      package = "ruifm/gitlinker.nvim";
      dependencies.lua = [ lazy.plenary.package ];

      env.blacklist = [ "vscode" "firenvim" ];
      opts.mappings = mapping;
      keys = mapping;
    };
  # }}}
  # {{{ paperplanes
  # export to pastebin like services
  satellite.neovim.lazy.paperlanes = {
    package = "rktjmp/paperplanes.nvim";
    cmd = "PP";
    opts.provider = "paste.rs";
  };
  # }}}
  # }}}
  # }}}
}
