{ config, upkgs, ... }:
{
  home.packages = [
    # NOTE: not in 25.11 yet! Can be removed once I'm on 26.05
    upkgs.vim-classic
  ];

  home.file.".vim".source =
    config.satellite.dev.path # .
      "home/features/neovim/vim/config";

  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.cacheHome}/vim/undo - - - 7d"
  ];
}
