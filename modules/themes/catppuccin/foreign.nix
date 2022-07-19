{ fetchFromGitHub, ... }: {
  tmux = fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    sha256 = "1vz6srk4zfgsjpwb7xa7n9mg5kfb3x7aq963mwqnl8m4zvmcy8vz";
    rev = "1c87a9e1d2fac21815497ed7f599a1c1208d40cd";
  };
  sddm = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    sha256 = "065g331issjw8jh0hjqfhc98sqhb4i77mwx7y9v5wdy32pmym9i1";
    rev = "cfe861c1ea9c92e4b4cd5acb3627021e1d2f5e6c";
  };
  grub = fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    sha256 = "0ra1psb37wsgdag5swfwwzcgy73014j34c9njnvxz1jdv0k56qlc";
    rev = "b2919a93ef37ea1b220bab90fa0a5fa3a26eec0b";
  };
  gtk = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    sha256 = "1l8xr651mh4lf26s5d7jfk7vv1jxh9qld0w5hgcnqsa13lncsd5h";
    rev = "7bfea1f0d569010998302c8242bb857ed8a83058";
  };
  rofi = fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    sha256 = "076xkxxmwhffns35n3cnbn6lz9i4w6hvma1g4mdw0zmayvy5rmpj";
    rev = "2e14344b789d70d42853ffe2abe79b3b85b16e24";
  };
  alacritty = fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    sha256 = "0ka3a79i4iv2ahkc3hy41b4s220z8ydkrma52fvcqmphw1y3h7ml";
    rev = "c2d27714b43984e47347c6d81216b7670a3fe07f";
  };
  wallpapers = fetchFromGitHub {
    owner = "catppuccin";
    repo = "wallpapers";
    sha256 = "0p1xfr6hv4w0zw04jpbylwiy3n2w9zpxfq041ql8j3jh4inn0w1g";
    rev = "72f67e1e198cf07bdfd30f70c074a946e5dc64b4";
  };
  xresources = fetchFromGitHub {
    owner = "catppuccin";
    repo = "xresources";
    sha256 = "1ffx73l6s0pkf4d4g5lp2d0cfxjrbczsr5fy45i0503sa279fan7";
    rev = "a9cd582faeef2f7410eb7d4b5a83d026e3f2b865";
  };
}
