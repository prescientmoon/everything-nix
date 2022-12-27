local M = {}

function M.setup()
  local paq = require("paq")
  local themePackages = require("my.theme").deps
  local base = {
    "nvim-lua/plenary.nvim", -- async utility lib it seems?
    --------------------------------- Unuported
    "folke/neoconf.nvim", -- per project neovim configuration
    "neovim/nvim-lspconfig", -- configures lsps for me
    "folke/neodev.nvim", -- lua support
    "windwp/nvim-autopairs", -- closes pairs for me (should look for a better one)
    "nvim-telescope/telescope.nvim", -- fuzzy search for say opening files
    "purescript-contrib/purescript-vim", -- purescript support
    "terrortylor/nvim-comment", -- allows toggling line comments
    "nvim-treesitter/nvim-treesitter-textobjects", -- the lean plugin wants me to install this, lol
    -- "startup-nvim/startup.nvim", -- splash screen
    "glepnir/dashboard-nvim", -- similar to startup.nvim
    "kyazdani42/nvim-web-devicons", -- nice looking icons
    "nvim-lualine/lualine.nvim", -- customizable status line
    "kyazdani42/nvim-tree.lua", -- file tree
    "lervag/vimtex", -- latex support
    "jose-elias-alvarez/null-ls.nvim", -- generic language server
    "nvim-telescope/telescope-file-browser.nvim", -- file creation/deletion menu
    "onsails/lspkind.nvim", -- show icons in lsp completion menus
    "preservim/vimux", -- interact with tmux from within vim
    "christoomey/vim-tmux-navigator", -- easly switch between tmux and vim panes
    "kana/vim-arpeggio", -- chord support, let"s fucking goooo
    { "andweeb/presence.nvim", run = ":DownloadUnicode" }, -- discord rich presence
    "Julian/lean.nvim", -- lean support
    "kmonad/kmonad-vim", -- kmonad config support
    -- "LucHermitte/lh-vim-lib", -- dependency for lh-brackets
    -- "LucHermitte/lh-brackets", -- kinda useless bruh, should find something better
    -- Cmp related stuff
    "hrsh7th/cmp-nvim-lsp", -- lsp completion
    "hrsh7th/cmp-buffer", -- idr what this is
    "hrsh7th/cmp-path", -- path completion ig?
    "hrsh7th/cmp-cmdline", -- cmdline completion perhaps?
    "hrsh7th/nvim-cmp", -- completion engine
    "L3MON4D3/LuaSnip", -- snippeting engine
    "saadparwaiz1/cmp_luasnip", -- snippet support for cmp
    "wakatime/vim-wakatime", -- track time usage
    "vmchale/dhall-vim", -- dhall syntax highlighting
    "folke/which-key.nvim", -- shows what other keys I can press to finish a command
    { "psliwka/vim-smoothie", opt = true }, -- smooth scrolling
    -- "easymotion/vim-easymotion", -- removes the need for spamming w or e
    "ggandor/leap.nvim", -- removes the need for spamming w or e
    "tpope/vim-surround", -- work with brackets, quotes, tags, etc
    "MunifTanjim/nui.nvim", -- ui stuff required by idris2
    "ShinKage/idris2-nvim", -- idris2 support
    "udalov/kotlin-vim", -- kotlin support
    "haringsrob/nvim_context_vt", -- show context on closing parenthesis
    -- "vuki656/package-info.nvim", -- shows latest versions in package.json
    "j-hui/fidget.nvim", -- show progress for lsp stuff
    "stevearc/dressing.nvim", -- better ui I guess
    "rktjmp/paperplanes.nvim", -- export to pastebin like services
    "anuvyklack/hydra.nvim", -- keybinds where you only hit the head once
    "jbyuki/venn.nvim", -- draw ascii diagrams
    "hrsh7th/cmp-omni", -- omnifunc source for cmp
    "ekickx/clipboard-image.nvim", -- paste images from clipbaord
    "glacambre/firenvim", -- vim inside chrome
    "lewis6991/impatient.nvim", -- faster startup times
    "tpope/vim-abolish", -- abbreviations on steroids
    "mrjones2014/smart-splits.nvim", -- the name says it all
    "phaazon/mind.nvim", -- Organize shit as trees
    "bfredl/nvim-luadev", -- lua repl thingy
    "akinsho/toggleterm.nvim", -- cool terminal thingy
    "folke/noice.nvim", -- better ui for cmd line and other stuff
    "rcarriga/nvim-notify", -- better notifiaction ui
    "hkupty/iron.nvim", -- repl support
    "0styx0/abbremand.nvim", -- dependency for the next thing
    "0styx0/abbreinder.nvim", -- reminds you of abbreviations
    "ellisonleao/glow.nvim", -- md preview (in terminal)
    "frabjous/knap", -- md preview
    "tpope/vim-sleuth", -- automatically set options based on current file
    "mateiadrielrafael/scrap.nvim", -- vim-abolish rewrite
    "kevinhwang91/promise-async", -- required by nvim-ufo
    "kevinhwang91/nvim-ufo", -- better folds and stuff
    "ThePrimeagen/refactoring.nvim", -- refactoring
    "gpanders/nvim-moonwalk", -- configure nvim in any language which compiles to lua
    "teal-language/vim-teal", -- teal language support

    -- Git stuff
    "ruifm/gitlinker.nvim", -- generate permalinks for code
    { "TimUntersberger/neogit", opt = true } -- magit clone
  }

  table.insert(base, 2, { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  for _, v in ipairs(themePackages) do
    -- append package in the base list
    table.insert(base, v)
  end

  paq(base)
end

return M
