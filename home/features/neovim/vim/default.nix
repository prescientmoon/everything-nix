{
  config,
  pkgs,
  upkgs,
  lib,
  ...
}:
let
  # NOTE: not in 25.11 yet! Non-unstable packages can be used once I'm on 26.05
  pkg = import ./package.nix {
    inherit lib;
    pkgs = upkgs;
  };
in
{
  home.packages = [ pkg ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # Running "man <foo>" will open the manpage inside vim.
    MANPAGER = "${lib.getExe pkg} -M +MANPAGER -";
  };

  # Make the vim config directory a symlink to ./config. Note that this version
  # of Vim does not support the XDG directory specification. Oh well!
  home.file.".vim".source =
    config.satellite.dev.path # .
      "home/features/neovim/vim/config";

  # Ensure the undo & swap directories exists, and delete files inside them
  # after 7 days.
  systemd.user.tmpfiles.rules = [
    "d ${config.xdg.cacheHome}/vim/undo - - - 7d"
    "d ${config.xdg.cacheHome}/vim/swap - - - 7d"
  ];

  # We install plugins in the most rudimentary way possible — by simply cloning
  # them into a directory Vim can pick them up from!
  xdg.dataFile = {
    "vim/pack/nix/start/vim-zig".source = pkgs.fetchgit {
      url = "https://codeberg.org/ziglang/zig.vim";
      rev = "4842ab8cb1b000a9acb0a06170d404d12a154918";
      sha256 = "0452kls4hzyir5rqf7b3a6yvp545y4y51rijjk3kkqizpihhll1n";
    };

    "vim/pack/nix/start/vim-nix".source = pkgs.fetchFromGitHub {
      owner = "LnL7";
      repo = "vim-nix";
      rev = "7235c7ce2cea530cb6b59bc3e46d4bfe917d15c8";
      sha256 = "109narpbw9kbih7ai49p1zw7j2bj7nzpk3n02z80jcbgb48zqs8y";
    };
  };
}
