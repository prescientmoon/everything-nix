{ pkgs, ... }:
let
  config-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "config-nvim";
    src = ../../dotfiles/neovim;
  };
in

{
  home-manager.users.adrielus.programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    extraConfig = ''
      let g:disable_paq = v:true
      luafile ${config-nvim}/init.lua
    '';

    extraPackages = with pkgs; [
      fzf # Required by lua-fzf

      # Language servers
      nodePackages.typescript # typescript
      easy-purescript-nix.purescript-language-server # purescript
      sumneko-lua-language-server # lua
      efm-langserver # auto-formatting
      rnix-lsp # nix

      # Formatters
      luaformatter # lua
    ];

    plugins = with pkgs.vimPlugins;
      with pkgs.vimExtraPlugins; [
        config-nvim # my neovim config
        github-nvim-theme # github theme for neovim
        nvim-lspconfig # configures lsps for me
        nvim-autopairs # close pairs for me
        fzf-lua # fuzzy search for say opening files
        purescript-vim # purescript syntax highlighting
        nvim-comment # allows toggling line-comments
	nvim-treesitter # use treesitter for syntax highlighting
      ];
  };
}
