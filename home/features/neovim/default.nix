{
  upkgs,
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  neovimNightly = false;

  # Toggles for including tooling related to a given language
  packedTargets = {
    csharp = false;
    elm = false;
    tooling = true; # Stuff useful for config editing
    latex = true;
    lua = true;
    nix = true;
    odin = false;
    purescript = false;
    python = false;
    rust = false;
    typst = true;
    web = true;
  };

  korora = inputs.korora.lib;
  nlib = import ../../../modules/common/korora-neovim.nix { inherit lib korora; } {
    tempestModule = "my.tempest";
  };

  mirosSnippetCache = "${config.xdg.cacheHome}/miros";
  obsidianVault = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/personal/stellar-sanctum";

  generated =
    with nlib;
    generateConfig {
      # Pre-plugin configuration
      pre = {
        # {{{ General options
        "0:general-options" = {
          # {{{ Starter page
          callback =
            # lua
            thunk ''
              local cwd = vim.loop.cwd()
              local header

              if cwd == ${encode obsidianVault} then
                header = ${encode (builtins.readFile ./headers/obsidian.txt)}
              else
                header = ${encode (builtins.readFile ./headers/main.txt)}
              end

              require("my.starter").setup({ header = header })
            '';
          # }}}
        };
        # }}}
        # {{{ Misc keybinds
        "1:misc-keybinds" = {
          keys = [
            # {{{ Chords
            # Different chords get remapped to f-keys by my Kanata config.
            #
            # Exit insert mode using *jk*
            (keymap "iv" "<f10>" "<esc>" "Exit insert mode")

            # Use global clipboard using *cp*
            (keymap "nv" "<f11>" ''"+'' "Use global clipboard")

            # Save using *ji*
            (nmap "<f12>" (thunk ''
              -- If we don't do this, the statusbar will flash for a second...
              vim.cmd([[silent! write]])
              vim.opt.stl = vim.opt.stl
            '') "Save current file")
            # }}}
            # {{{ Diagnostics
            (nmap "J" (vim /diagnostic/open_float) "Open current diagnostic")
            (nmap "qj" "J" "join lines")
            (nmap "<leader>dl" (thunk ''
              vim.diagnostic.setloclist()
              vim.cmd("lopen")
            '') "[D]iagnostic loclist")
            (nmap "<leader>dq" (thunk ''
              vim.diagnostic.setqflist()
              vim.cmd("copen")
            '') "[D]iagnostic qflist")
            # }}}
            # {{{ Other misc keybinds
            (nmap "<leader>rw" ":%s/<C-r><C-w>/" "[R]eplace [w]ord in file")
            (nmap "<leader>yp" "<cmd>!curl --data-binary @% https://paste.rs | wl-copy<cr>"
              "[y]ank [p]aste.rs link to clipboard"
            )
            # }}}
            {
              mode = "v";
              mapping = "<C-i>";
              action = _: tempest /createVisualFold (vim /fn/input "Fold name: ");
            }
          ];

        };
        # }}}
        # {{{ Neovide config
        "4:configure-neovide" = {
          cond = whitelist "neovide";
          vim.g = {
            neovide_transparency = tempest /theme/transparency/applications/value;
            neovide_cursor_animation_length = 4.0e-2;
            neovide_cursor_animate_in_insert_mode = false;
          };
        };
        # }}}
        # {{{ Language specific overrides
        "5:language-specific-settings" = {
          autocmds = [
            # {{{ Nix
            {
              event = "FileType";
              group = "UserNixSettings";
              pattern = "nix";
              action = {
                keys = {
                  mapping = "<leader>lg";
                  action =
                    _:
                    let
                      cmd = _: vim /cmd ":%!${lib.getExe pkgs.update-nix-fetchgit}";
                    in
                    tempest /withSavedCursor cmd;
                  desc = "Update all fetchgit calls";
                };
              };
            }
            # }}}
          ];
        };
        # }}}
      };

      # Plugins
      lazy = {
        # {{{ libraries
        # {{{ plenary
        plenary = {
          package = "nvim-lua/plenary.nvim";
          # Autoload when running tests
          cmd = [
            "PlenaryBustedDirectory"
            "PlenaryBustedFile"
          ];
        };
        # }}}
        # {{{ web-devicons
        web-devicons.package = "nvim-tree/nvim-web-devicons";
        # }}}
        # {{{ scrap
        scrap = {
          package = "prescientmoon/scrap.nvim";
          event = "InsertEnter";
        };
        # }}}
        # }}}
        # {{{ UI
        # {{{ mini.statusline
        mini-statusline = {
          package = "echasnovski/mini.statusline";
          name = "mini.statusline";
          dependencies.lua = [ "web-devicons" ];

          lazy = false;

          opts.content.inactive =
            _:
            require "mini.statusline" /combine_groups [
              {
                hl = "MiniStatuslineFilename";
                strings = [ (vim /fn/expand "%:t") ];
              }
            ];

          opts.content.active =
            # lua
            thunk ''
              local st = require("mini.statusline");
              local mode, mode_hl = st.section_mode({ trunc_width = 120 })
              local git = st.section_git({ trunc_width = 75 })
              local diagnostics = st.section_diagnostics({ trunc_width = 75 })

              return st.combine_groups({
                { hl = mode_hl, strings = { mode } },
                { hl = "MiniStatuslineDevinfo", strings = { git } },
                { hl = "MiniStatuslineFilename", strings = {
                  vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.")
                } },
                "%=", -- End left alignment
                { hl = "MiniStatuslineFilename", strings = { diagnostics } },
                { hl = "MiniStatuslineDevinfo", strings = { vim.bo.filetype } },
              })
            '';
        };
        # }}}
        # {{{ mini.files
        mini-files = {
          package = "echasnovski/mini.files";
          name = "mini.files";
          dependencies.lua = [ "web-devicons" ];

          keys = {
            mapping = "<c-s-f>";
            desc = "[S]earch [F]iles";
            action =
              # lua
              thunk ''
                local files = require("mini.files")
                if not files.close() then
                  files.open(vim.api.nvim_buf_get_name(0))
                  files.reveal_cwd()
                end
              '';
          };

          opts.windows.preview = false;
          opts.mappings.go_in_plus = "l";
        };
        # }}}
        # {{{ quicker.nvim
        quicker-nvim = {
          package = "stevearc/quicker.nvim";
          name = "quicker.nvim";
          dependencies.lua = [ "web-devicons" ];
          event = "FileType qf";
          opts = { };
        };
        # }}}
        # {{{ harpoon
        harpoon = {
          package = "ThePrimeagen/harpoon";
          event = "VeryLazy";
          keys =
            let
              goto = key: index: {
                desc = "Goto harpoon file ${toString index}";
                mapping = "<c-s>${key}";
                action = _: require "harpoon.ui" /nav_file index;
              };
            in
            [
              {
                desc = "Add file to [h]arpoon";
                mapping = "<leader>H";
                action = _: require "harpoon.mark" /add_file none;
              }
              {
                desc = "Toggle harpoon quickmenu";
                mapping = "<c-a>";
                action = _: require "harpoon.ui" /toggle_quick_menu none;
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
        # {{{ telescope
        telescope = {
          package = "nvim-telescope/telescope.nvim";
          event = "VeryLazy";

          # {{{ Dependencies
          dependencies = {
            nix = [ pkgs.ripgrep ];
            lua = [
              "plenary"
              {
                # We want a prebuilt version of this plugin
                dir = pkgs.vimPlugins.telescope-fzf-native-nvim;
                name = "telescope-fzf-native";
              }
            ];
          };
          # }}}
          # {{{ Keymaps
          keys =
            let
              nmap = mapping: action: desc: {
                inherit mapping desc;
                action = "<cmd>Telescope ${action} theme=ivy<cr>";
              };

              findFilesByExtension =
                mapping: extension: tag:
                nmap "<leader>f${mapping}" "find_files find_command=rg,--files,--glob=**/*.${extension}"
                  "Find ${tag} files";
            in
            [
              (nmap "<c-p>" "find_files" "File finder [p]alette")
              (nmap "<leader>da" "diagnostics root_dir=true" "[D]iagnostics")
              (nmap "<c-f>" "live_grep" "[F]ind in project")
              (nmap "<c-t>" "builtin" "[T]elescope pickers")
              # {{{ Files by extension
              (findFilesByExtension "tx" "tex" "[t]ex")
              (findFilesByExtension "ts" "ts" "[t]ypescript")
              (findFilesByExtension "ty" "typ" "[t]ypst")
              (findFilesByExtension "l" "lua" "[l]ua")
              (findFilesByExtension "n" "nix" "[n]ua")
              (findFilesByExtension "p" "purs" "[p]urescript")
              (findFilesByExtension "h" "hs" "[h]askell")
              (findFilesByExtension "e" "elm" "[e]lm")
              (findFilesByExtension "r" "rs" "[r]ust")
              # }}}
            ];
          # }}}
          # {{{ Disable folds in telescope windows
          config.autocmds = {
            event = "FileType";
            pattern = "TelescopeResults";
            group = "TelescopeResultsDisableFolds";
            action.vim.opt.foldenable = false;
          };
          # }}}
          # {{{ Load fzf extension
          config.callback = _: require "telescope" /load_extension "fzf";
          # }}}
          # {{{ Options
          opts.defaults.mappings.i."<C-h>" = "which_key";
          opts.extensions.fzf = {
            fuzzy = true;
            override_generic_sorter = true;
            override_file_sorter = true;
          };
          # }}}
        };
        # }}}
        # {{{ dressing
        dressing = {
          package = "stevearc/dressing.nvim";

          event = "VeryLazy";

          opts = {
            select.backend = [
              "nui"
              "builtin"
              "telescope"
            ];
            input.insert_only = false;
          };
        };
        # }}}
        # }}}
        # {{{ visual
        # The line between `ui` and `visual` is a bit rought. I currenlty mostly judge
        # it by vibe.
        # {{{ indent-blankline
        indent-blankline = {
          package = "lukas-reineke/indent-blankline.nvim";
          main = "ibl";

          event = "VeryLazy";
          config = true;

          # {{{ Keybinds
          keys =
            let
              # {{{ List of fold-related keybinds
              foldKeybinds = [
                "zo"
                "zO"
                "zc"
                "zC"
                "za"
                "zA"
                "zv"
                "zx"
                "zX"
                "zm"
                "zM"
                "zr"
                "zR"
              ];
            in
            # }}}
            [ (nmap "<leader>si" "<cmd>IBLToggle<cr>" "Toggle blankline indentation") ]
            ++ (lib.forEach foldKeybinds (
              from:
              nmap from "${from}<cmd>IBLToggle<cr><cmd>IBLToggle<cr>" "Overriden ${from} (fold-related thing)"
            ));
          # }}}}
        };
        # }}}
        # {{{ live-command
        # Live command preview for commands like :norm
        live-command = {
          package = "smjonas/live-command.nvim";
          version = "remote"; # https://github.com/smjonas/live-command.nvim/pull/29
          main = "live-command";

          event = "CmdlineEnter";
          opts.commands.Norm.cmd = "norm";
          opts.commands.G.cmd = "g";

          keys = keymap "v" "N" ":Norm " "Map lines in [n]ormal mode";
        };
        # }}}
        # {{{ fidget
        fidget = {
          package = "j-hui/fidget.nvim";
          tag = "legacy";

          event = "BufReadPre";
          config = true;
        };
        # }}}
        # {{{ treesitter
        treesitter =
          let
            allGrammars =
              with upkgs.vimPlugins;
              (nvim-treesitter.withPlugins (
                plugins:
                with plugins;
                [
                  (upkgs.tree-sitter.buildGrammar {
                    language = "odin";
                    version = "unstable-2025-07-18";
                    src = pkgs.fetchgit {
                      url = "https://git.moonythm.dev/starlitcanopy/tree-sitter-odin.git";
                      rev = "61e6575f73e23aff4b6b3dda55aedf0a42acc591";
                      sha256 = "sha256-YAuBrH4q/vHwg3oKmY1vnP06+h/TFh+bzyj5Im9C0xQ=";
                    };
                  })
                ]
                ++ [
                  ada
                  agda
                  awk
                  bash
                  bibtex
                  c
                  comment
                  cpp
                  css
                  csv
                  dhall
                  djot
                  editorconfig
                  elm
                  fish
                  git_config
                  git_rebase
                  gitattributes
                  gitcommit
                  gitignore
                  glsl
                  go
                  haskell
                  html
                  hyprlang
                  idris
                  javascript
                  json
                  just
                  latex
                  lua
                  luadoc
                  markdown
                  markdown_inline
                  nix
                  purescript
                  python
                  rasi
                  regex
                  requirements
                  scss
                  sql
                  ssh_config
                  svelte
                  tmux
                  toml
                  tsx
                  typescript
                  typst
                  vim
                  vimdoc
                  xml
                  yaml
                  zathurarc
                  zig
                ]
              ));
          in
          {
            # I use the nixpkgs version since the normal one can break at times
            dir = pkgs.symlinkJoin {
              name = "treesitter-with-parsers";
              # I don't think nix likes it when we install this manually (normally
              # we'd pass this to nixos/HM's neovim configuration modules).
              paths = [
                allGrammars
                allGrammars.dependencies
              ];
            };

            # package = "nvim-treesitter/nvim-treesitter";
            main = "nvim-treesitter";

            dependencies.nix = [
              pkgs.tree-sitter
              pkgs.nodejs
            ];

            event = "VeryLazy";
          };
        # }}}
        # }}}
        # {{{ editing
        # {{{ text navigation
        # {{{ flash
        flash = {
          package = "folke/flash.nvim";

          keys =
            let
              nmap = mode: mapping: action: desc: {
                inherit mapping desc mode;
                action = _: require "flash" /${action} none;
              };
            in
            [
              (nmap "nxo" "s" "jump" "Flash")
              (nmap "nxo" "S" "treesitter" "Flash Treesitter")
              (nmap "o" "r" "remote" "Remote Flash")
              (nmap "ox" "R" "treesitter_search" "Treesitter Search")
              (nmap "c" "<C-S>" "toggle" "Toggle Flash Search")
            ];

          # Disable stuff like f/t/F/T
          opts.modes.char.enabled = false;
        };
        # }}}
        # {{{ ftft (quickscope but written in lua)
        ftft = {
          package = "gukz/ftFT.nvim";

          keys = [
            "f"
            "F"
            "t"
            "T"
          ];
          config = true;
        };
        # }}}
        # }}}
        # {{{ clipboard-image
        clipboard-image = {
          package = "postfen/clipboard-image.nvim";

          cmd = "PasteImg";

          keys = {
            mapping = "<leader>p";
            action = "<cmd>PasteImg<cr>";
            desc = "[P]aste image from clipboard";
          };

          opts.default.img_name = importFrom ./plugins/clipboard-image.lua "img_name";
          opts.tex = {
            img_dir = [
              "%:p:h"
              "img"
            ];
            affix = "\\includegraphics[width=\\textwidth]{%s}";
          };
          opts.typst = {
            img_dir = [
              "%:p:h"
              "img"
            ];
            affix = ''#image("%s", width: 100)'';
          };
        };
        # }}}
        # {{{ lastplace
        lastplace = {
          package = "ethanholz/nvim-lastplace";

          event = "BufReadPre";

          opts.lastplace_ignore_buftype = [
            "quickfix"
            "nofile"
            "help"
          ];
        };
        # }}}
        # {{{ undotree
        undotree = {
          package = "mbbill/undotree";

          cmd = "UndotreeToggle";
          keys = nmap "<leader>u" "<cmd>UndoTreeToggle<cr>" "[U]ndo tree";
        };
        # }}}
        # {{{ mini.ai
        mini-ai = {
          package = "echasnovski/mini.ai";
          name = "mini.ai";
          event = "VeryLazy";

          opts =
            _: # lazy, as we import mini.ai inside
            let
              balanced = from: [
                "%b${from}"
                "^.().*().$"
              ];
            in
            {
              custom_textobjects = {
                b = balanced "()";
                B = balanced "{}";
                r = balanced "[]";
                v = [
                  "⟨.-⟩"
                  "^⟨().*()⟩$"
                ];
                q = balanced "\"\"";
                Q = balanced "``";
                a = balanced "''";
                A = require "mini.ai" /gen_spec/argument none;
              };
            };
        };
        # }}}
        # {{{ mini.align
        mini-align = {
          package = "echasnovski/mini.align";
          name = "mini.align";

          config = true;
          keys = [
            {
              mode = "nxv";
              mapping = "ga";
            }
            {
              mode = "nxv";
              mapping = "gA";
            }
          ];
        };
        # }}}
        # {{{ mini.comment
        mini-comment = {
          package = "echasnovski/mini.comment";
          name = "mini.comment";

          config = true;
          keys = [
            {
              mapping = "gc";
              mode = "nxv";
            }
            "gcc"
          ];
        };
        # }}}
        # {{{ mini.surround
        mini-surround = {
          package = "echasnovski/mini.surround";
          name = "mini.surround";

          keys = lib.flatten [
            # ^ doing the whole `flatten` thing to lie to my formatter
            {
              mapping = "<tab>s";
              mode = "nv";
            }
            [
              "<tab>d"
              "<tab>f"
              "<tab>F"
              "<tab>h"
              "<tab>r"
            ]
          ];

          # {{{ Keybinds
          opts.mappings = {
            add = "<tab>s"; # Add surrounding in Normal and Visul modes
            delete = "<tab>d"; # Delete surrounding
            find = "<tab>f"; # Find surrounding (to the right)
            find_left = "<tab>F"; # Find surrounding (to the left)
            highlight = "<tab>h"; # Highlight surrounding
            replace = "<tab>r"; # Replace surrounding
            update_n_lines = ""; # Update `n_lines`
          };
          # }}}
          # {{{ Custom surroundings
          opts.custom_surroundings =
            let
              mk = balanced: input: left: right: {
                input = [
                  input
                  (if balanced then "^.%s*().-()%s*.$" else "^.().*().$")
                ];
                output = { inherit left right; };
              };

              # Make unicode
              mu = left: right: {
                input = [ "${left}().-()${right}" ];
                output = { inherit left right; };
              };
            in
            {
              b = mk true "%b()" "(" ")";
              B = mk true "%b{}" "{" "}";
              r = mk true "%b[]" "[" "]";
              q = mk false "\".-\"" "\"" "\"";
              Q = mk false "`.-`" "`" "`";
              a = mk false "'.-'" "'" "'";
              A = mk false "⟨.-⟩" "⟨" "⟩";
              v = mu "⟨" "⟩";
            };
          # }}}
        };
        # }}}
        # {{{ mini.operators
        mini-operators = {
          package = "echasnovski/mini.operators";
          name = "mini.operators";

          config = true;
          keys =
            let
              operator = prefix: key: [
                {
                  mapping = "${prefix}${key}";
                  mode = "nv";
                }
                "${prefix}${key}${key}"
              ];
            in
            lib.flatten [
              (operator "g" "=")
              (operator "g" "m")
              (operator "g" "x")
              (operator "g" "s")
              (operator "q" "r")
            ];

          opts.replace.prefix = "qr";
        };
        # }}}
        # {{{ mini.pairs
        # mini-pairs = {
        #   package = "echasnovski/mini.pairs";
        #   name = "mini.pairs";
        #
        #   # We could specify all the generated bindings, but I don't think it's worth it
        #   event = [
        #     "InsertEnter"
        #     "CmdlineEnter"
        #   ];
        #
        #   opts.mappings = {
        #     "⟨" = {
        #       action = "open";
        #       pair = "⟨⟩";
        #       neigh_pattern = "[^\\].";
        #     };
        #     "⟩" = {
        #       action = "close";
        #       pair = "⟨⟩";
        #       neigh_pattern = "[^\\].";
        #     };
        #   };
        # };
        # }}}
        # {{{ luasnip
        # snippeting engine
        luasnip = {
          package = "L3MON4D3/LuaSnip";
          version = "v2";

          config =
            _:
            do [
              (require "luasnip" /config/setup {
                enable_autosnippets = true;
                update_events = [
                  "TextChanged"
                  "TextChangedI"
                ];
              })

              (require "luasnip.loaders.from_lua" /lazy_load { fs_event_providers.libuv = true; })
            ];

          # {{{ Keybinds
          keys = [
            {
              mode = "i";
              expr = true;
              mapping = "<tab>";
              action =
                # lua
                thunk ''
                  local luasnip = require("luasnip")

                  if not luasnip.jumpable(1) then
                    return "<tab>"
                  end

                  vim.schedule(function()
                    luasnip.jump(1)
                  end)

                  return "<ignore>"
                '';
              desc = "Jump to next snippet tabstop";
            }
            {
              mode = "i";
              mapping = "<s-tab>";
              action = _: require "luasnip" /jump (-1);
              desc = "Jump to previous snippet tabstop";
            }
            {
              mode = "is";
              mapping = "<c-a>";
              action = "<Plug>luasnip-prev-choice";
              desc = "Previous snippet node choice";
            }
            {
              mode = "is";
              mapping = "<c-f>";
              action = "<Plug>luasnip-next-choice";
              desc = "Next snippet node choice";
            }
          ];
          # }}}
        };
        # }}}
        # {{{ miros
        # snippeting generation language
        miros = with import inputs.miros { inherit pkgs; }; {
          dir = miros-nvim;
          dependencies.nix = [ miros ];

          ft = "miros";

          keys = {
            mapping = "<leader>rm";
            action =
              "<cmd>!miros generate"
              + " -i ${config.satellite.dev.path "home/features/neovim/snippets"}"
              + " -o ${mirosSnippetCache}/luasnippets"
              + " luasnip -r my.luasnip <cr>";
            desc = "[R]erun [m]iros";
          };
        };
        # }}}
        # {{{ sops.nvim
        # secret editing
        sops = {
          package = "trixnz/sops.nvim";
          dependencies.nix = [ pkgs.sops ];

          # This plugin is security-critical. I've read through the source
          # myself, and have pinned the respective commit.
          commit = "dacb68c";
          ft = [
            "yaml"
            "json"
          ];
        };
        # }}}
        # }}}
        # {{{ IDE
        # {{{ lspconfig
        lspconfig = {
          # {{{ Nix dependencies
          dependencies.nix =
            with lib.lists;
            with packedTargets;
            (
              optionals web [
                pkgs.nodePackages.typescript
                pkgs.nodePackages_latest.vscode-langservers-extracted
                pkgs.nodePackages.typescript-language-server
                pkgs.svelte-language-server
                pkgs.emmet-language-server
              ]
              ++ optionals lua [
                pkgs.lua-language-server
                pkgs.lua
              ]
              ++ optionals nix [ upkgs.nixd ]
              ++ optionals latex [
                upkgs.texlab
                upkgs.texlive.combined.scheme-full
              ]
              ++ optionals elm [
                pkgs.elmPackages.elm
                pkgs.elmPackages.elm-format
                pkgs.elmPackages.elm-language-server
              ]
              ++ optionals purescript [
                pkgs.purescript-language-server
                pkgs.nodePackages.purs-tidy
              ]
              ++ optionals csharp [ pkgs.csharp-ls ]
              ++ optionals odin [ pkgs.ols ]
              ++ optionals tooling [
                pkgs.hyprls
                pkgs.just-lsp
              ]
              ++ optionals typst [
                upkgs.typst
                upkgs.typstyle
                upkgs.tinymist # The typst language server
              ]
              ++ optionals python [
                pkgs.ruff
              ]
            );
          # }}}

          package = "neovim/nvim-lspconfig";

          # event = "VeryLazy";

          lazy = false;
          keys = nmap "<leader>li" "<cmd>LspInfo<cr>" "[L]sp [i]nfo";
          config =
            _:
            importFrom ./plugins/lspconfig.lua "config" {
              # We handle formatting using null-ls and prettierd
              ts_ls.on_attach = client: ''
                ${client}.server_capabilities.documentFormattingProvider = false
              '';

              nixd.offset_encoding = "utf-8";
              nixd.settings.nixd =
                let
                  satellite = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/satellite";
                  hostname = "tethys"; # not sure how to get this dynamically in HM
                in
                {
                  formatting.command = [ ];
                  diagnostic.suppress = [
                    "sema-escaping-with"
                    "sema-extra-with"
                  ];
                  nixpkgs.expr = ''import (builtins.getFlake "${satellite}").inputs.nixpkgs { }'';
                  options = {
                    nixos.expr = ''(builtins.getFlake "${satellite}").nixosConfigurations.${hostname}.options'';
                    home-manager.expr = ''(builtins.getFlake "${satellite}").homeConfigurations."${config.home.username}@${hostname}".options'';
                  };
                };
            };
        };
        # }}}
        # {{{ conform
        conform = {
          dependencies.lua = [ "lspconfig" ];
          dependencies.nix =
            with lib.lists;
            with packedTargets;
            (
              [ pkgs.codespell ]
              ++ optional lua pkgs.stylua
              ++ optional python pkgs.ruff
              ++ optionals web [
                pkgs.nodePackages_latest.prettier
                pkgs.nodePackages_latest.prettier_d_slim
              ]
              ++ optionals nix [ pkgs.nixfmt-rfc-style ]
            );
          package = "stevearc/conform.nvim";

          event = "VeryLazy";

          opts.format_on_save = { };
          opts.default_format_opts.lsp_format = "fallback";
          opts.formatters_by_ft =
            let
              prettier = {
                stop_after_first = true;
                __list = [
                  "prettierd"
                  "prettier"
                ];
              };
            in
            {
              "*" = [
                # "codespell" # this one causes issues sometimes
                # "trim_whitespace"
              ];
              lua = [ "stylua" ];
              python = [ "ruff_format" ];

              javascript = prettier;
              typescript = prettier;
              javascriptreact = prettier;
              typescriptreact = prettier;
              html = prettier;
              nix = [ "nixfmt" ];
              css = prettier;
              markdown = prettier;

              # I have the justfile formatter
              just.lsp_format = "never";
            };
        };
        # }}}
        # {{{ cmp
        cmp = {
          package = "hrsh7th/nvim-cmp";
          dependencies.lua = [
            # {{{ Completion sources
            "hrsh7th/cmp-nvim-lsp"
            "hrsh7th/cmp-buffer"
            "hrsh7th/cmp-emoji"
            "hrsh7th/cmp-cmdline"
            "hrsh7th/cmp-path"
            "saadparwaiz1/cmp_luasnip"
            # }}}
            "onsails/lspkind.nvim" # show icons in lsp completion menus
            "luasnip"
          ];

          event = [
            "InsertEnter"
            "CmdlineEnter"
          ];
          config = importFrom ./plugins/cmp.lua "config";
        };
        # }}}
        # }}}
        # {{{ language support
        # {{{ haskell support
        haskell-tools = {
          package = "mrcjkb/haskell-tools.nvim";
          dependencies.lua = [ "plenary" ];
          version = "^6";
          lazy = false;

          init.vim.g.haskell_tools = {
            hls.settings.haskell = {
              formattingProvider = "fourmolu";

              # This seems to work better with custom preludes
              # See this issue https://github.com/fourmolu/fourmolu/issues/357
              # plugin.fourmolu.config.external = true;
            };
          };
        };
        # }}}
        # {{{ rustacean
        rustacean = {
          package = "mrcjkb/rustaceanvim";
          dependencies.nix = lib.lists.optionals packedTargets.rust [
            pkgs.rust-analyzer
            pkgs.rustfmt
          ];

          lazy = false; # This plugin is already lazy

          config.autocmds = {
            group = "RustaceanSettings";
            event = "FileType";
            pattern = "rs";
            action.keys = {
              mapping = "<leader>lc";
              action = "<cmd>RustLsp openCargo<cr>";
              desc = "Open [c]argo.toml";
            };
          };
        };
        # }}}
        # {{{ rocq
        # Do not load this plugin, but do install it for ftdetect and syntax
        # highlighting.
        coqtail = {
          package = "whonore/Coqtail";
          init.vim.g.loaded_coqtail = 1;
          init.vim.g."coqtail#supported" = 0;
        };
        vsrocq = {
          package = "tomtomjhj/vsrocq.nvim";
          dependencies.lua = [ "coqtail" ];
          ft = "coq";
          opts = {
            # vsrocq = { ... };
            # lsp = { ... };
          };
        };
        # }}}
        # }}}
        # {{{ external
        # These plugins integrate neovim with external services
        # {{{ wakatime
        wakatime = {
          package = "wakatime/vim-wakatime";
          dependencies.nix = [ pkgs.wakatime-cli ];

          event = "VeryLazy";
        };
        # }}}
        # {{{ discord rich presence
        discord-rich-presence = {
          enabled = false;
          package = "andweeb/presence.nvim";
          main = "presence";

          event = "VeryLazy";
          config = true;
        };
        # }}}
        # {{{ gitlinker
        # generate permalinks for code
        gitlinker = rec {
          package = "ruifm/gitlinker.nvim";
          dependencies.lua = [ "plenary" ];

          opts.mappings = "<leader>yg";
          keys = {
            mapping = opts.mappings;
            desc = "[y]ank [g]it permalink";
          };
        };
        # }}}
        # {{{ obsidian
        obsidian =
          let
            dateFormat = "%Y-%m-%d";
          in
          {
            package = "epwalsh/obsidian.nvim";
            dependencies.lua = [ "plenary" ];

            event = "VeryLazy";
            cond = lua "vim.loop.cwd() == ${encode obsidianVault}";

            config.keys =
              let
                nmap = mapping: action: desc: {
                  inherit mapping desc;
                  action = "<cmd>Obsidian${action}<cr>";
                };
              in
              [
                (nmap "<C-O>" "QuickSwitch<cr>" "[o]pen note")
                (nmap "<leader>ot" "Today" "[t]oday's note")
                (nmap "<leader>oy" "Yesterday" "[y]esterday's note")
                (nmap "<leader>oi" "Template" "[i]nstantiate template")
                (nmap "<leader>on" "Template New note.md" "new [n]ote template")
                (nmap "<leader>od" "Template New dream.md" "new [d]ream template")
              ];

            opts = {
              dir = obsidianVault;
              notes_subdir = "chaos";

              daily_notes = {
                folder = "daily";
                date_format = dateFormat;
                template = "New daily note.md";
              };

              templates = {
                subdir = "templates";
                date_format = dateFormat;
                time_format = "%H:%M";
              };

              completion = {
                nvim_cmp = true;
                min_chars = 2;
              };

              new_notes_location = "current_dir";
              mappings = { };
              disable_frontmatter = true;
            };
          };
        # }}}
        # }}}
      };
    };

  # {{{ extraRuntime
  # Experimental nix module generation
  generatedConfig = config.satellite.lib.lua.writeFile "lua/nix" "init" generated.lua;

  extraRuntime = lib.concatStringsSep "," [
    generatedConfig
    mirosSnippetCache
    "${pkgs.vimPlugins.lazy-nvim}"
  ];
  # }}}
  # {{{ Client wrapper
  # Wraps a neovim client, providing the dependencies
  # and setting some flags:
  wrapClient =
    {
      base,
      name,
      binName ? name,
      extraArgs ? "",
      wrapFlags ? lib.id,
    }:
    let
      startupScript =
        config.satellite.lib.lua.writeFile "." "startup" # lua
          ''
            vim.g.nix_extra_runtime = ${nlib.encode extraRuntime}
            vim.g.nix_projects_dir = ${nlib.encode config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}
            vim.g.nix_theme = ${config.satellite.colorscheme.lua}
            -- Provide hints as to what app we are running in
            -- (Useful because neovide does not provide the info itself right away)
            vim.g.nix_neovim_app = ${nlib.encode name}
          '';
      extraFlags = lib.escapeShellArg (wrapFlags ''--cmd "lua dofile('${startupScript}/startup.lua')"'');
    in
    pkgs.symlinkJoin {
      inherit (base) name meta;
      paths = [ base ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${binName} \
          --prefix PATH : ${lib.makeBinPath generated.dependencies} \
          --add-flags ${extraFlags} \
          ${extraArgs}
      '';
    };
  # }}}
  # {{{ Clients
  neovim = wrapClient {
    base =
      if neovimNightly then
        inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
      else
        upkgs.neovim;
    name = "nvim";
  };

  neovide = wrapClient {
    base = pkgs.neovide;
    name = "neovide";
    extraArgs = "--set NEOVIDE_MULTIGRID true";
    wrapFlags = flags: "-- ${flags}";
  };
in
# }}}
{
  satellite.lua.styluaConfig = ../../../stylua.toml;

  # {{{ Basic config
  # Link files in the appropriate places
  xdg.configFile.nvim.source = config.satellite.dev.path "home/features/neovim/config";
  home.sessionVariables.EDITOR = "nvim";
  home.file.".nvim_nix_runtime".source = generatedConfig;

  # Install packages
  home.packages = [
    neovim
    pkgs.vimclip
    neovide
  ];
  # }}}
  # {{{ Persistence
  satellite.persistence.at.state.apps.neovim.directories = [
    ".local/state/nvim"
    "${config.xdg.dataHome}/nvim"
  ];

  satellite.persistence.at.cache.apps.neovim.directories = [
    "${config.xdg.cacheHome}/nvim"
    mirosSnippetCache
  ];
  # }}}

  home.sessionVariables.MANPAGER = "${lib.getExe neovim} +Man!";
}
