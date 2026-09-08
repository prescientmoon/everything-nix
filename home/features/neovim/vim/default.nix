{
  config,
  pkgs,
  upkgs,
  lib,
  ...
}:
let
  # NOTE: not in 25.11 yet! Can be removed once I'm on 26.05
  pkg = upkgs.vim-classic;
in
{
  home.packages = [ pkg ];

  # Running man <foo> will open the manpage inside vim!
  home.sessionVariables.MANPAGER = "${lib.getExe pkg} +Man!";

  home.file.".vim".source =
    config.satellite.dev.path # .
      "home/features/neovim/vim/config";

  # Ensure the undo directory exists, and delete files inside it after 7 days.
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.cacheHome}/vim/undo - - - 7d"
  ];

  xdg.dataFile."vim/pack/nix/start/vim-zig".source = pkgs.fetchgit {
    url = "https://codeberg.org/ziglang/zig.vim";
    rev = "4842ab8cb1b000a9acb0a06170d404d12a154918";
    sha256 = "0452kls4hzyir5rqf7b3a6yvp545y4y51rijjk3kkqizpihhll1n";
  };
}
