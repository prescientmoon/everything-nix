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
    sha256 = "1rkmrr2fvczjz5wgcdfi7hyhp0s2lnn1jhan0qq896kvc1pmwqid";
    rev = "e2a0dc15f63ba7429cef79cf08db8d3f2a3018c1";
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
    sha256 = "1q9iq0agdk5rm5cfnpr1b1bzy6fdx67pvkakx478j1dlyr1d78bl";
    rev = "87a79fd2bf07accc694455df30a32a82b1b31f4f";
  };
  rofi = fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    sha256 = "1bs7l5mpqryjl7dz6pi419n1p9c68362vnczj0lcpbxnfpw0af24";
    rev = "39fc2a0b51d594e559cb03bf9d4e743cb96f7b01";
  };
  alacritty = fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    sha256 = "1l7fa4gncx08j48mjd1zwz7j1j4vm08rbs1vx53cdj3yp3s4j50m";
    rev = "0f0247693730de64d50a9d915c3306b234c6f11b";
  };
  wallpapers = fetchFromGitHub {
    owner = "catppuccin";
    repo = "wallpapers";
    sha256 = "0d68di2nn9as7y2rxq1v4b5d0s89y53m8v2ls8nfm1rrggny1iqx";
    rev = "72b8b3e1749300fbaf6f8e736a65a4f41ac7d48d";
  };
  xresources = fetchFromGitHub {
    owner = "catppuccin";
    repo = "xresources";
    sha256 = "1ffx73l6s0pkf4d4g5lp2d0cfxjrbczsr5fy45i0503sa279fan7";
    rev = "a9cd582faeef2f7410eb7d4b5a83d026e3f2b865";
  };
}
