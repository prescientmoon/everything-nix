{ upkgs, pkgs, lib, config, inputs, ... }:
let
  # Toggles for including tooling related to a given language
  packedTargets = {
    elm = false;
    latex = true;
    lua = true;
    nix = true;
    purescript = false;
    python = false;
    rust = false;
    typst = true;
    web = true;
    csharp = false;
  };

  korora = inputs.korora.lib;
  nlib = import ../../../modules/common/korora-neovim.nix
    { inherit lib korora; }
    { tempestModule = "my.tempest"; };

  mirosSnippetCache = "${config.xdg.cacheHome}/miros";
  obsidianVault = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/stellar-sanctum";

  generated = nlib.generateConfig
    (lib.fix (self: with nlib; {
      # {{{ Pre-plugin config
      pre = {
        # {{{ General options
        "0:general-options" = {
          vim.g = {
            # Disable filetype.vim
            do_filetype_lua = true;
            did_load_filetypes = false;

            # Set leader
            mapleader = " ";
          };

          vim.opt = {
            # Basic options
            joinspaces = false; # No double spaces with join (mapped to qj in my config)
            list = false; # I don't want to show things like tabs
            cmdheight = 0; # Hide command line when it's not getting used
            spell = true; # Spell checker

            # tcqj are there by default, and "r" automatically continues comments on enter
            formatoptions = "tcqjr";

            scrolloff = 4; # Starts scrolling 4 lines from the edge of the screen
            termguicolors = true; # True color support

            wrap = false; # Disable line wrap (by default)
            wildmode = [ "list" "longest" ]; # Command-line completion mode
            completeopt = [ "menu" "menuone" "noselect" ];

            undofile = true; # persist undos!!

            # {{{ Line numbers
            number = true; # Show line numbers
            relativenumber = true; # Relative line numbers
            # }}}
            # {{{ Indents
            expandtab = true; # Use spaces for the tab char
            shiftwidth = 2; # Size of an indent
            tabstop = 2; # Size of tab character
            shiftround = true; # When using < or >, rounds to closest multiple of shiftwidth
            smartindent = true; # Insert indents automatically
            # }}}
            # {{{ Casing 
            ignorecase = true; # Ignore case
            smartcase = true; # Do not ignore case with capitals
            # }}}
            # {{{ Splits
            splitbelow = true; # Put new windows below current
            splitright = true; # Put new windows right of current
            # }}}
            # {{{ Folding
            foldmethod = "marker"; # use {{{ }}} for folding
            foldcolumn = "0"; # show no column with folds on the left
            # }}}
          };

          # {{{Disable pseudo-transparency;
          autocmds = {
            event = "FileType";
            group = "WinblendSettings";
            action.vim.opt.winblend = 0;
          };
          #  }}}

          # {{{ Starter page
          callback = thunk /* lua */''
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
          # {{{ Global keybinds 
          keys =
            # {{{ Keybind helpers 
            let dmap = mapping: action: desc: {
              inherit mapping desc;
              action = lua "vim.diagnostic.${action}";
            };
            in
            # }}}
            [
              # {{{ Free up q and Q
              (nmap "<c-q>" "q" "Record macro")
              (nmap "<c-s-q>" "Q" "Repeat last recorded macro")
              (unmap "q")
              (unmap "Q")
              # }}}
              # {{{ Chords
              # Different chords get remapped to f-keys by my [my kaanta config](../../../hosts/nixos/common/optional/services/kanata.nix).
              #
              # Exit insert mode using *jk*
              (keymap "iv" "<f10>" "<esc>" "Exit insert mode")

              # Use global clipboard using *cp*
              (keymap "nv" "<f11>" ''"+'' "Use global clipboard")
              # Save using *ji*
              (nmap "<f12>"
                (thunk ''
                  -- If we don't do this, the statusbar will flash for a second...
                  vim.cmd([[silent! write]])
                  vim.opt.stl = vim.opt.stl
                '') "Save current file")
              # }}}
              # {{{ Newline without comments 
              {
                mode = "i";
                mapping = "<c-cr>";
                action = thunk /* lua */ ''
                  vim.paste({ "", "" }, -1)
                '';
                desc = "Insert newline without continuing the current comment";
              }
              {
                mode = "i";
                mapping = "<c-s-cr>";
                # This is a bit scuffed and might not work for all languages
                action = "<cmd>norm O<bs><bs><bs><cr>";
                desc = "Insert newline above without continuing the current comment";
              }
              # }}}
              # {{{ Diagnostics
              (dmap "[d" "goto_prev" "Goto previous [d]iagnostic")
              (dmap "]d" "goto_next" "Goto next [d]iagnostic")
              (dmap "J" "open_float" "Open current diagnostic")
              (dmap "<leader>D" "setloclist" "[D]iagnostic loclist")
              (nmap "qj" "J" "join lines")
              # }}}
              # {{{ Other misc keybinds 
              (nmap "<Leader>a" "<C-^>" "[A]lternate file")
              (unmap "<C-^>")
              (nmap "Q" ":wqa<cr>" "Save all files and [q]uit")
              (nmap "<leader>rw"
                ":%s/<C-r><C-w>/"
                "[R]eplace [w]ord in file")
              (nmap "<leader>sw"
                (lua ''require("my.helpers.wrap").toggle'')
                "toggle word [w]rap")
              (nmap "<leader>ss"
                (thunk /* lua */ "vim.opt.spell = not vim.o.spell")
                "toggle [s]pell checker")
              (nmap "<leader>yp"
                "<cmd>!curl --data-binary @% https://paste.rs<cr>"
                "[y]ank [p]aste.rs link")
              # }}}
            ];
          # }}}
          # {{{ Autocmds
          autocmds = [
            # {{{ Exit certain buffers with qq 
            {
              event = "FileType";
              pattern = [ "help" ];
              group = "BasicBufferQuitting";
              action.keys =
                nmap "qq" "<cmd>close<cr>" "[q]uit current buffer";
            }
            # }}}
            # {{{ Enable wrap movemenets by default in certain filetypes
            {
              event = "FileType";
              pattern = [ "markdown" "typst" "tex" ];
              group = "EnableWrapMovement";
              action = lua ''require("my.helpers.wrap").enable'';
            }
            # }}}
          ];
          # }}}
        };
        # }}}
        # {{{ Manage cmdheight 
        "2:manage-cmdheight".autocmds = [
          {
            event = "CmdlineEnter";
            group = "SetCmdheightCmdlineEnter";
            action.vim.opt.cmdheight = 1;
          }
          {
            event = "CmdlineLeave";
            group = "SetCmdheightCmdlineLeave";
            action.vim.opt.cmdheight = 0;
          }
        ];
        # }}}
        # {{{ Lsp settings
        "3:lsp-settings" = {
          # {{{ Change lsp on-hover borders
          vim.lsp.handlers."textDocument/hover" = lua
            ''vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })'';
          vim.lsp.handlers."textDocument/signatureHelp" = lua
            ''vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })'';
          # }}}
          # {{{ Create on-attach keybinds
          autocmds = {
            event = "LspAttach";
            group = "UserLspConfig";
            action =
              let nmap = mapping: action: desc:
                nlib.nmap mapping
                  (lua "vim.lsp.buf.${action}")
                  desc;
              in
              {
                mkContext = event: {
                  bufnr = lua "${event}.buf";
                  client = lua /* lua */
                    "vim.lsp.get_client_by_id(${event}.data.client_id)";
                };
                keys = [
                  (nlib.nmap "<leader>li" "<cmd>LspInfo<cr>" "[L]sp [i]nfo")
                  (nmap "gd" "definition" "[G]o to [d]efinition")
                  (nmap "<leader>gi" "implementation" "[G]o to [i]mplementation")
                  (nmap "<leader>gr" "references" "[G]o to [r]eferences")
                  (nmap "L" "signature_help" "Signature help")
                  (nmap "<leader>c" "code_action" "[C]ode actions")
                  (keymap "v" "<leader>c" ":'<,'> lua vim.lsp.buf.range_code_action()" "[C]ode actions")
                  (nmap "<leader>wa" "add_workspace_folder" "[W]orkspace [A]dd Folder")
                  (nmap "<leader>wr" "remove_workspace_folder" "[W]orkspace [R]emove Folder")
                  (nlib.nmap "<leader>wl"
                    (thunk /* lua */ ''
                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    '') "[W]orkspace [L]ist Folders")
                ];
                callback = {
                  cond = ctx: lua ''
                    return ${ctx}.client.supports_method("textDocument/hover")
                  '';
                  keys = nmap "K" "hover" "Hover";
                };
              };
          };
          # }}}
        };
        # }}}
        # {{{ Neovide config
        "4:configure-neovide" = {
          cond = whitelist "neovide";
          vim.g = {
            neovide_transparency = lua ''D.tempest.theme.transparency.applications.value'';
            neovide_cursor_animation_length = 0.04;
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
                vim.opt.commentstring = "# %s";
                keys = {
                  mapping = "<leader>lg";
                  action = thunk /* lua */ ''
                    D.tempest.withSavedCursor(function()
                      vim.cmd(":%!${lib.getExe pkgs.update-nix-fetchgit}")
                    end)
                  '';
                  desc = "Update all fetchgit calls";
                };
              };
            }
            # }}}
            # {{{ Purescript
            {
              event = "FileType";
              group = "UserPurescriptSettings";
              pattern = "purs";
              action.vim.opt = {
                expandtab = true; # Use spaces for the tab char
                commentstring = "-- %s";
              };
            }
            # }}}
          ];
        };
        # }}}
      };
      # }}}
      # {{{ Plugins
      lazy = {
        # {{{ libraries
        # {{{ plenary
        plenary = {
          package = "nvim-lua/plenary.nvim";
          # Autoload when running tests
          cmd = [ "PlenaryBustedDirectory" "PlenaryBustedFile" ];
        };
        # }}}
        # {{{ nui
        nui.package = "MunifTanjim/nui.nvim";
        # }}}
        # {{{ web-devicons
        web-devicons.package = "nvim-tree/nvim-web-devicons";
        # }}}
        # {{{ scrap
        scrap = {
          package = "prescientmoon/scrap.nvim";

          event = "InsertEnter";
          config.setup."my.abbreviations" = true;
        };
        # }}}
        # }}}
        # {{{ ui
        # {{{ mini.statusline
        mini-statusline = {
          package = "echasnovski/mini.statusline";
          name = "mini.statusline";
          dependencies.lua = [ "web-devicons" ];

          cond = blacklist [ "vscode" "firenvim" ];
          lazy = false;

          opts.content.inactive = thunk /* lua */ ''
            require("mini.statusline").combine_groups({
              { hl = "MiniStatuslineFilename", strings = { vim.fn.expand("%:t") } },
            })
          '';

          opts.content.active = thunk /* lua */ ''
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

          cond = blacklist [ "vscode" "firenvim" ];
          keys = {
            mapping = "<c-s-f>";
            desc = "[S]earch [F]iles";
            action = thunk /* lua */ ''
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
        # {{{ harpoon
        harpoon = {
          package = "ThePrimeagen/harpoon";
          event = "VeryLazy";
          keys =
            let goto = key: index: {
              desc = "Goto harpoon file ${toString index}";
              mapping = "<c-s>${key}";
              action = thunk
                /* lua */ ''require("harpoon.ui").nav_file(${toString index})'';
            };
            in
            [
              {
                desc = "Add file to [h]arpoon";
                mapping = "<leader>H";
                action = thunk
                  /* lua */ ''require("harpoon.mark").add_file()'';
              }
              {
                desc = "Toggle harpoon quickmenu";
                mapping = "<c-a>";
                action = thunk
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
        # {{{ telescope
        telescope = {
          package = "nvim-telescope/telescope.nvim";
          version = "0.1.x";
          cond = blacklist "vscode";
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

              findFilesByExtension = mapping: extension: tag:
                nmap
                  "<leader>f${mapping}"
                  "find_files find_command=rg,--files,--glob=**/*.${extension}"
                  "Find ${tag} files";
            in
            [
              (nmap "<c-p>" "find_files" "File finder [p]alette")
              (nmap "<leader>d" "diagnostics" "[D]iagnostics")
              (nmap "<c-f>" "live_grep" "[F]ind in project")
              (nmap "<leader>t" "builtin" "[T]elescope pickers")
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
          config.callback = thunk /* lua */ ''
            require("telescope").load_extension("fzf")
          '';
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

          cond = blacklist "vscode";
          event = "VeryLazy";

          opts = {
            select.backend = [ "nui" "builtin" "telescope" ];
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

          cond = blacklist "vscode";
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
              # }}}
            in
            [
              (nmap
                "<leader>si"
                "<cmd>IBLToggle<cr>"
                "Toggle blankline indentation")
            ] ++
            (lib.forEach foldKeybinds (from: nmap
              from
              "${from}<cmd>IBLToggle<cr><cmd>IBLToggle<cr>"
              "Overriden ${from} (fold-related thing)"
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

          cond = blacklist "vscode";
          event = "BufReadPre";
          config = true;
        };
        # }}}
        # {{{ treesitter
        treesitter = {
          # REASON: more grammars
          # dir = upkgs.vimPlugins.nvim-treesitter.withAllGrammars;
          package = "nvim-treesitter/nvim-treesitter";
          main = "nvim-treesitter.configs";

          dependencies.nix = [ pkgs.tree-sitter ];

          cond = blacklist "vscode";
          event = "VeryLazy";

          #{{{ Highlighting
          opts.highlight = {
            enable = true;
            disable = [ "kotlin" ]; # This one seemed a bit broken
            additional_vim_regex_highlighting = false;
          };
          #}}}

          opts.indent.enable = true;
        };
        # }}}
        # }}}
        # {{{ editing 
        # {{{ text navigation
        # {{{ flash
        flash = {
          package = "folke/flash.nvim";

          cond = blacklist "vscode";
          keys =
            let nmap = mode: mapping: action: desc: {
              inherit mapping desc mode;
              action = thunk /* lua */ ''require("flash").${action}()'';
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

          cond = blacklist "vscode";
          keys = [ "f" "F" "t" "T" ];
          config = true;
        };
        # }}}
        # }}}
        # {{{ clipboard-image
        clipboard-image = {
          package = "postfen/clipboard-image.nvim";

          cond = blacklist "firenvim";
          cmd = "PasteImg";

          keys = {
            mapping = "<leader>p";
            action = "<cmd>PasteImg<cr>";
            desc = "[P]aste image from clipboard";
          };

          opts.default.img_name = importFrom ./plugins/clipboard-image.lua "img_name";
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
        lastplace = {
          package = "ethanholz/nvim-lastplace";

          cond = blacklist "vscode";
          event = "BufReadPre";

          opts.lastplace_ignore_buftype = [ "quickfix" "nofile" "help" ];
        };
        # }}}
        # {{{ undotree
        undotree = {
          package = "mbbill/undotree";

          cond = blacklist "vscode";
          cmd = "UndotreeToggle";
          keys = nmap
            "<leader>u"
            "<cmd>UndoTreeToggle<cr>"
            "[U]ndo tree";
        };
        # }}}
        # {{{ mini.ai
        mini-ai = {
          package = "echasnovski/mini.ai";
          name = "mini.ai";
          event = "VeryLazy";

          opts = _: # lazy, as we import mini.ai inside
            let balanced = from: [ "%b${from}" "^.().*().$" ];
            in
            {
              custom_textobjects = {
                b = balanced "()";
                B = balanced "{}";
                r = balanced "[]";
                v = [ "⟨.-⟩" "^⟨().*()⟩$" ];
                q = balanced "\"\"";
                Q = balanced "``";
                a = balanced "''";
                A = lua "require('mini.ai').gen_spec.argument()";
              };
            };
        };
        # }}}
        # {{{ mini.comment
        mini-comment = {
          package = "echasnovski/mini.comment";
          name = "mini.comment";

          config = true;
          keys = [
            { mapping = "gc"; mode = "nxv"; }
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
            { mapping = "<tab>s"; mode = "nv"; }
            [ "<tab>d" "<tab>f" "<tab>F" "<tab>h" "<tab>r" ]
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
            let mk = balanced: input: left: right: {
              input = [
                input
                (if balanced
                then "^.%s*().-()%s*.$"
                else "^.().*().$")
              ];
              output = { inherit left right; };
            };
            in
            {
              b = mk true "%b()" "(" ")";
              B = mk true "%b{}" "{" "}";
              r = mk true "%b[]" "[" "]";
              v = mk true "%b⟨⟩" "⟨" "⟩";
              q = mk false "\".-\"" "\"" "\"";
              Q = mk false "`.-`" "`" "`";
              a = mk false "'.-'" "'" "'";
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
            let operator = key: [
              { mapping = "g${key}"; mode = "nv"; }
              "g${key}${key}"
            ];
            in
            lib.flatten [
              (operator "=")
              (operator "x")
              (operator "r")
              (operator "s")
            ];
        };
        # }}}
        # {{{ mini.pairs
        mini-pairs = {
          package = "echasnovski/mini.pairs";
          name = "mini.pairs";

          # We could specify all the generated bindings, but I don't think it's worth it
          event = [ "InsertEnter" "CmdlineEnter" ];
        };
        # }}}
        # {{{ luasnip
        # snippeting engine
        luasnip = {
          package = "L3MON4D3/LuaSnip";
          version = "v2";

          cond = blacklist "vscode";
          config = thunk ''
            require("luasnip").config.setup(${encode {
              enable_autosnippets = true;
              update_events = ["TextChanged" "TextChangedI"];
            }})

            require("luasnip.loaders.from_lua").lazy_load(${encode {
              fs_event_providers.libuv = true;
            }})
          '';

          # {{{ Keybinds
          keys = [
            {
              mode = "i";
              expr = true;
              mapping = "<tab>";
              action = thunk /* lua */ ''
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
              action = thunk /* lua */ ''
                require("luasnip").jump(-1)
              '';
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
        miros = with inputs.miros.packages.${pkgs.system}; {
          dir = miros-nvim;
          dependencies.nix = [ miros ];

          cond = blacklist "vscode";
          ft = "miros";

          keys = {
            mapping = "<leader>rm";
            action = "<cmd>!miros generate"
              + " -i ${config.satellite.dev.path "home/features/neovim/snippets"}"
              + " -o ${mirosSnippetCache}/luasnippets"
              + " luasnip -r my.luasnip <cr>";
            desc = "[R]erun [m]iros";
          };
        };
        # }}}
        # }}}
        # {{{ ide
        # {{{ lspconfig
        lspconfig = {
          # {{{ Nix dependencies
          dependencies.nix = with lib.lists; with packedTargets; (
            optionals web [
              pkgs.nodePackages.typescript
              pkgs.nodePackages_latest.vscode-langservers-extracted
              pkgs.nodePackages.typescript-language-server
            ] ++
            optionals lua [
              pkgs.lua-language-server
              pkgs.lua
            ] ++
            optionals nix [
              pkgs.nil
              pkgs.nixd
            ] ++
            optionals latex [
              pkgs.texlab
              pkgs.texlive.combined.scheme-full
            ] ++
            optionals elm [
              pkgs.elmPackages.elm
              pkgs.elmPackages.elm-format
              pkgs.elmPackages.elm-language-server
            ] ++
            optionals purescript [
              pkgs.purescript-language-server
              pkgs.nodePackages.purs-tidy
            ] ++
            optionals csharp [
              pkgs.csharp-ls
            ]
          );
          # }}}
          dependencies.lua = [ "neoconf" "neodev" ];
          package = "neovim/nvim-lspconfig";

          cond = blacklist "vscode";
          event = "VeryLazy";

          config = importFrom ./plugins/lspconfig.lua "config";
        };
        # }}}
        # {{{ conform
        conform = {
          dependencies.lua = [ "lspconfig" ];
          dependencies.nix = with lib.lists; with packedTargets; (
            [ pkgs.codespell ] ++
            optional lua pkgs.stylua ++
            optional python pkgs.ruff ++
            optionals web [
              pkgs.nodePackages_latest.prettier
              pkgs.nodePackages_latest.prettier_d_slim
            ]
          );
          package = "stevearc/conform.nvim";

          cond = blacklist "vscode";
          event = "VeryLazy";

          opts.format_on_save.lsp_fallback = true;
          opts.formatters_by_ft = let prettier = [ [ "prettierd" "prettier" ] ]; in
            {
              "*" = [
                # "codespell" # this one causes issues sometimes
                "trim_whitespace"
              ];
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
        # {{{ neodev
        neodev = {
          package = "folke/neodev.nvim";
          config = true;
        };
        # }}}
        # {{{ neoconf
        neoconf = {
          package = "folke/neoconf.nvim";

          cmd = "Neoconf";

          # Provide autocomplete for every language server
          opts.plugins.jsonls.configure_servers_only = false;
          opts.import = {
            vscode = true; # local .vscode/settings.json
            coc = false; # global/local coc-settings.json
            nlsp = false; # global/local nlsp-settings.nvim json settings
          };
        };
        # }}}
        # {{{ null-ls
        null-ls = {
          package = "jose-elias-alvarez/null-ls.nvim";
          dependencies.lua = [ "lspconfig" ];
          dependencies.nix =
            lib.lists.optional
              packedTargets.python
              pkgs.ruff;

          cond = blacklist "vscode";
          event = "VeryLazy";

          opts = thunk /* lua */ ''
            local p = require("null-ls")
            return {
              sources = {
                p.builtins.diagnostics.ruff
              }
            }
          '';
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

          cond = blacklist "vscode";
          event = [ "InsertEnter" "CmdlineEnter" ];
          config = importFrom ./plugins/cmp.lua "config";
        };
        # }}}
        # }}}
        # {{{ language support
        # {{{ haskell support
        haskell-tools = {
          package = "mrcjkb/haskell-tools.nvim";
          dependencies.lua = [ "plenary" ];
          version = "^2";

          cond = blacklist "vscode";
          ft = [ "haskell" "lhaskell" "cabal" "cabalproject" ];

          config.vim.g.haskell_tools = {
            hls.settings.haskell = {
              formattingProvider = "fourmolu";

              # This seems to work better with custom preludes
              # See this issue https://github.com/fourmolu/fourmolu/issues/357
              plugin.fourmolu.config.external = true;
            };

            # I think this wasn't showing certain docs as I expected (?)
            tools.hover.enable = false;
          };
        };
        # }}}
        # {{{ rust support
        # {{{ rust-tools 
        rust-tools = {
          package = "simrat39/rust-tools.nvim";
          dependencies.nix =
            lib.lists.optionals
              packedTargets.rust
              [ pkgs.rust-analyzer pkgs.rustfmt ];

          cond = blacklist "vscode";
          ft = "rust";

          opts.server.on_attach = tempestBufnr {
            keys = {
              mapping = "<leader>lc";
              action = "<cmd>RustOpenCargo<cr>";
              desc = "Open [c]argo.toml";
            };
          };
        };
        # }}}
        # {{{ crates 
        crates = {
          package = "saecki/crates.nvim";
          dependencies.lua = [ "plenary" ];

          cond = blacklist "vscode";
          event = "BufReadPost Cargo.toml";

          # {{{ Set up null_ls source
          opts.null_ls = {
            enabled = true;
            name = "crates";
          };
          # }}}

          config.autocmds = [
            # {{{ Load cmp source on insert 
            {
              event = "InsertEnter";
              group = "CargoCmpSource";
              pattern = "Cargo.toml";
              action = thunk /* lua */ ''
                require("cmp").setup.buffer({ sources = { { name = "crates" } } })
              '';
            }
            # }}}
            # {{{ Load keybinds on attach
            {
              event = "BufReadPost";
              group = "CargoKeybinds";
              pattern = "Cargo.toml";
              # # {{{ Register which-key info
              # action.callback = contextThunk /* lua */ ''
              #  require("which-key").register({
              #    ["<leader>lc"] = {
              #      name = "[l]ocal [c]rates",
              #      bufnr = context.bufnr
              #    },
              #  })
              # '';
              # }}}

              action.keys = _:
                let
                  # {{{ Keymap helpers 
                  nmap = mapping: action: desc: {
                    inherit mapping desc;
                    action = lua /* lua */ ''require("crates").${action}'';
                  };

                  keyroot = "<leader>lc";
                  # }}}
                in
                # {{{ Keybinds
                [
                  (nmap "${keyroot}t" "toggle" "[c]rates [t]oggle")
                  (nmap "${keyroot}r" "reload" "[c]rates [r]efresh")

                  (nmap "${keyroot}H" "open_homepage" "[c]rate [H]omephage")
                  (nmap "${keyroot}R" "open_repository" "[c]rate [R]epository")
                  (nmap "${keyroot}D" "open_documentation" "[c]rate [D]ocumentation")
                  (nmap "${keyroot}C" "open_crates_io" "[c]rate [C]rates.io")

                  (nmap "${keyroot}v" "show_versions_popup" "[c]rate [v]ersions")
                  (nmap "${keyroot}f" "show_features_popup" "[c]rate [f]eatures")
                  (nmap "${keyroot}d" "show_dependencies_popup" "[c]rate [d]eps")
                  (nmap "K" "show_popup" "[c]rate popup")
                ];
              # }}}
            }
            # }}}
          ];
        };
        # }}}
        # }}}
        # {{{ lean support
        lean = {
          package = "Julian/lean.nvim";
          name = "lean";
          dependencies.lua = [
            "plenary"
            "lspconfig"
          ];

          cond = blacklist "vscode";
          ft = "lean";

          opts = {
            abbreviations = {
              builtin = true;
              cmp = true;
            };

            lsp.capabilites =
              importFrom ./plugins/lspconfig.lua "capabilities";

            lsp3 = false; # We don't want the lean 3 language server!
            mappings = true;
          };
        };
        # }}}
        # {{{ idris support
        idris = {
          package = "ShinKage/idris2-nvim";
          name = "idris";
          dependencies.lua = [
            "nui"
            "lspconfig"
          ];

          cond = blacklist "vscode";
          ft = [ "idris2" "lidris2" "ipkg" ];

          opts = {
            client.hover.use_split = true;
            serve.on_attach = tempestBufnr {
              # {{{ Keymaps
              keys =
                let keymap = mapping: action: desc: {
                  inherit desc;
                  mapping = "<leader>i${mapping}";
                  action = lua /* lua */ ''require("idris2.code_action").${action}'';
                };
                in
                [
                  (keymap "C" "make_case" "Make [c]ase")
                  (keymap "L" "make_lemma" "Make [l]emma")
                  (keymap "c" "add_clause" "Add [c]lause")
                  (keymap "e" "expr_search" "[E]xpression search")
                  (keymap "d" "generate_def" "Generate [d]efinition")
                  (keymap "s" "case_split" "Case [s]plit")
                  (keymap "h" "refine_hole" "Refine [h]ole")
                ];
              # }}}
            };
          };
        };
        # }}}
        # {{{ github actions
        github-actions = {
          package = "yasuhiroki/github-actions-yaml.vim";

          cond = blacklist "vscode";
          ft = [ "yml" "yaml" ];
        };
        # }}}
        # {{{ typst support
        typst = {
          package = "kaarmu/typst.vim";
          dependencies.nix =
            lib.lists.optionals
              packedTargets.typst
              [ upkgs.typst upkgs.typst-lsp upkgs.typstfmt ];

          cond = blacklist "vscode";
          ft = "typst";
        };
        # }}}
        # {{{ purescript support
        purescript = {
          package = "purescript-contrib/purescript-vim";

          cond = blacklist "vscode";
          ft = "purescript";
        };
        # }}}
        # {{{ hyprland support
        hyprland = {
          package = "theRealCarneiro/hyprland-vim-syntax";

          cond = blacklist "vscode";
          ft = "hypr";

          init.autocmds = {
            event = "BufRead";
            group = "DetectHyprlandConfig";
            pattern = "hyprland.conf";
            action.vim.opt.ft = "hypr";
          };
        };
        # }}}
        # {{{ typescript support
        # Required for yarn PNP to work
        rzip = {
          package = "lbrayner/vim-rzip";
          cond = blacklist "vscode";
          event = "VeryLazy";
        };
        # }}}
        # {{{ djot support
        djot =
          let djot = pkgs.fetchFromGitHub {
            owner = "jgm";
            repo = "djot";
            rev = "2fec440ab7a75a06a1e18c29a00de64ec7c94b9d";
            sha256 = "1xy2x1qbmv1kjxdpj2pjm03d9l7qrl0wx96gn5m0lkfxkg766i7z";
          };
          in
          {
            dir = "${djot}/editors/vim";
            cond = blacklist "vscode";
            ft = "djot";

            config.autocmds = {
              event = "FileType";
              group = "UserDjotSettings";
              pattern = "djot";
              action.vim.opt.commentstring = ''{\% %s \%}'';
            };
          };
        # }}}
        # }}}
        # {{{ external
        # These plugins integrate neovim with external services
        # {{{ wakatime
        wakatime = {
          package = "wakatime/vim-wakatime";
          dependencies.nix = [ pkgs.wakatime ];

          cond = blacklist [ "vscode" "firenvim" ];
          event = "VeryLazy";
        };
        # }}}
        # {{{ discord rich presence
        discord-rich-presence = {
          package = "andweeb/presence.nvim";
          main = "presence";

          cond = blacklist [ "vscode" "firenvim" ];
          event = "VeryLazy";
          config = true;
        };
        # }}}
        # {{{ gitlinker
        # generate permalinks for code
        gitlinker = rec {
          package = "ruifm/gitlinker.nvim";
          dependencies.lua = [ "plenary" ];

          cond = blacklist [ "vscode" "firenvim" ];
          opts.mappings = "<leader>yg";
          keys = {
            mapping = opts.mappings;
            desc = "[y]ank [g]it permalink";
          };
        };
        # }}}
        # {{{ obsidian
        obsidian =
          let dateFormat = "%Y-%m-%d";
          in
          {
            package = "epwalsh/obsidian.nvim";
            dependencies.lua = [ "plenary" ];

            event = "VeryLazy";
            cond = [
              (blacklist [ "vscode" "firenvim" ])
              (lua /* lua */ "vim.loop.cwd() == ${encode obsidianVault}")
            ];

            config.keys =
              let nmap = mapping: action: desc: {
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
                (nmap "<leader>od" "Template New note.md" "new [d]ream template")
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
                new_notes_location = "current_dir";
                prepend_note_id = true;
              };

              mappings = { };
              disable_frontmatter = true;
            };
          };
        # }}}
        # {{{ navigator
        navigator = {
          package = "numToStr/Navigator.nvim";
          cond = blacklist [ "vscode" "firenvim" "neovide" ];

          config = true;
          keys = [
            (nmap "<c-h>" "<cmd>NavigatorLeft<cr>" "Navigate left")
            (nmap "<c-j>" "<cmd>NavigatorDown<cr>" "Navigate down")
            (nmap "<c-k>" "<cmd>NavigatorUp<cr>" "Navigate up")
            (nmap "<c-l>" "<cmd>NavigatorRight<cr>" "Navigate right")
          ];
        };
        # }}}
        # }}}
      };
      # }}}
    }));
  # {{{ extraRuntime
  # Experimental nix module generation
  generatedConfig = (config.satellite.lib.lua.writeFile
    "lua/nix" "init"
    generated.lua);

  extraRuntime = lib.concatStringsSep "," [
    generatedConfig
    mirosSnippetCache
    "${pkgs.vimPlugins.lazy-nvim}"
  ];

  # }}}
  # {{{ Client wrapper
  # Wraps a neovim client, providing the dependencies
  # and setting some flags:
  wrapClient = { base, name, binName ? name, extraArgs ? "", wrapFlags ? lib.id }:
    let
      startupScript = config.satellite.lib.lua.writeFile
        "." "startup" /* lua */ ''
        vim.g.nix_extra_runtime = ${nlib.encode extraRuntime}
        vim.g.nix_projects_dir = ${nlib.encode config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}
        vim.g.nix_theme = ${config.satellite.colorscheme.lua}
        -- Provide hints as to what app we are running in
        -- (Useful because neovide does not provide the info itself right away)
        vim.g.nix_neovim_app = ${nlib.encode name}
      '';
      extraFlags = lib.escapeShellArg (wrapFlags
        ''--cmd "lua dofile('${startupScript}/startup.lua')"'');
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
      if config.satellite.toggles.neovim-nightly.enable
      then pkgs.neovim-nightly
      else upkgs.neovim;
    name = "nvim";
  };

  neovide = wrapClient {
    base = pkgs.neovide;
    name = "neovide";
    extraArgs = "--set NEOVIDE_MULTIGRID true";
    wrapFlags = flags: "-- ${flags}";
  };
  # }}}
in
{
  satellite.lua.styluaConfig = ../../../stylua.toml;

  imports = [ ../desktop/wakatime ];

  # {{{ Basic config
  # We want other modules to know that we are using neovim!
  satellite.toggles.neovim.enable = true;

  # Link files in the appropriate places
  xdg.configFile.nvim.source = config.satellite.dev.path "home/features/neovim/config";
  home.sessionVariables.EDITOR = "nvim";
  home.file.".nvim_nix_runtime".source = generatedConfig;

  # Install packages
  home.packages = [ neovim neovide pkgs.vimclip ];
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
}
