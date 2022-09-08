{ fetchFromGitHub, ... }: {
  tmux = fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    sha256 = "1x95db3wjjbaljk30db3iqjddxfp1gg2m9f0318vnincsdfllmz1";
    rev = "317159f824eeb4d170ecad34e0457281b13244d2";
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
    sha256 = "0d9vbq63bilikgnyzk9gfrzddvbvxi55k22cw8k0mdavfy24m1q4";
    rev = "fc5fba2896db095aee7b0d6442307c3035a24fa7";
  };
  gtk = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    sha256 = "1fzc7yzj9b9pc48qqaygbyskqjanb771x0i4ssn40hpbhj17n2ny";
    rev = "fc336313a84e0d7ec1a3499047fb1e73eef8a005";
  };
  rofi = fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    sha256 = "00p1pnnas281hdszzs8jki4l48vs76r0b5b5j5yas3vh3h352m99";
    rev = "5de33131d5904d4d96f4f218b1a54b9c79634965";
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
    sha256 = "08dh1av7kb921fdzkqhcp2yd2q848ay0kqgyf3zbnnvs0j92ap0q";
    rev = "046c2f9c3027af1b7aaca14377dda5ea19b61593";
  };
  zathura = fetchFromGitHub {
    owner = "catppuccin";
    repo = "zathura";
    sha256 = "17q2jn8bx712c0789vc00y9jb2vng7g7mnmqm8ypivrl616igzli";
    rev = "b9553c7e398c1a157e5543ea52d20e570f730dd6";
  };
}
