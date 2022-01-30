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

    plugins = with pkgs.vimExtraPlugins; [ config-nvim github-nvim-theme ];

  };
}
