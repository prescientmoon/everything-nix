local M = {}


function M.setup()
  local paq = require("paq")
  local themePackages = require("my.theme").deps
  local base = {
    "nvim-lua/plenary.nvim", -- async utility lib it seems?
    "neovim/nvim-lspconfig", -- configures lsps for me
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
    "psliwka/vim-smoothie", -- smooth scrolling
    "easymotion/vim-easymotion", -- removes the need for spamming w or e
    "tpope/vim-surround", -- work with brackets, quotes, tags, etc
    "MunifTanjim/nui.nvim", -- ui stuff required by idris2
    "ShinKage/idris2-nvim", -- idris2 support
    "udalov/kotlin-vim", -- kotlin support
    "haringsrob/nvim_context_vt", -- show context on closing parenthesis
    "vuki656/package-info.nvim", -- shows latest versions in package.json
    "stevearc/dressing.nvim", -- better ui I guess
    "rktjmp/paperplanes.nvim", -- export to pastebin like services
    "anuvyklack/hydra.nvim", -- keybinds where you only hit the head once
    "jbyuki/venn.nvim", -- draw ascii diagrams

    -- Git stuff
    "ruifm/gitlinker.nvim", -- generate permalinks for code
    "TimUntersberger/neogit" -- magit clone
  }

  -- This might get installed by nix!
  if os.getenv("NVIM_INSTALL_TREESITTER") then
    table.insert(base, 2, { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  end

  for _, v in ipairs(themePackages) do
    -- append package in the base list
    table.insert(base, v)
  end

  paq(base)
end

return M
