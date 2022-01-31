{ pkgs, ... }:
let
  config-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "config-nvim";
    src = ../../dotfiles/neovim;
  };
in {
  home-manager.users.adrielus.programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    extraConfig = ''
      let g:disable_paq = v:true
      luafile ${config-nvim}/init.lua
    '';

    extraPackages = [
      pkgs.nodePackages.typescript
      pkgs.easy-purescript-nix.purescript-language-server
    ];

    plugins = with pkgs.vimPlugins;
      with pkgs.vimExtraPlugins; [
        config-nvim # my neovim config
        github-nvim-theme # github theme for neovim
        nvim-lspconfig # configures lsps for me
        nvim-autopairs # close pairs for me
      ];
  };
}
