{ fetchFromGitHub, ... }: {
  tmux = fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    sha256 = "0frqk3g85licwl06qnck1bpxm9c7h9mj5law5vq28i2kv24qvv9n";
    rev = "87c33d683cf2b40e1340a10fa9049af2d28f5606";
  };
  sddm = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    sha256 = "19r04g28w17cg4c520qnz4gdf133vz8wlgjv6538wymh13pazh84";
    rev = "da92da8ba221c85a3d0722cd35efece616c487cf";
  };
  grub = fetchFromGitHub {
    owner = "catppuccin";
    repo = "grub";
    sha256 = "06ji9w3n36c5kdkqavpnx1bb9xz4l83i1fx059a4gwkvni5lapkp";
    rev = "3f62cd4174465631b40269a7c5631e5ee86dec45";
  };
  gtk = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    sha256 = "16dnfaj2w34m9i0b1jcg8wpaz5zdscl56gl3hqs4b7nkap1lan01";
    rev = "359c584f607c021fcc657ce77b81c181ebaff6de";
  };
  rofi = fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    sha256 = "063qwhy9hpy7i7wykliccpy9sdxhj77v6ry3ys69dwcchmspyn3j";
    rev = "b5ebfaf11bb90f1104b3d256e4671c6abb66d060";
  };
  alacritty = fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    sha256 = "0x90ac9v9j93i8l92nn1lhzwn6kzcg55v5xv7mg6g8rcrxlsm0xk";
    rev = "8f6b261375302657136c75569bdbd6dc3e2c67c4";
  };
  wallpapers = fetchFromGitHub {
    owner = "catppuccin";
    repo = "wallpapers";
    sha256 = "055080z71zf752psmgywhkm51jhba5a1b23nnb9wqhksxd5saa0n";
    rev = "61d997b8f4c33f6890b0d138bfed6329f3aff794";
  };
  xresources = fetchFromGitHub {
    owner = "catppuccin";
    repo = "xresources";
    sha256 = "0jj30xhpdgpl2ii67rv181c8pdgy88jzqnc584z4zpq4am3z4yip";
    rev = "8caaef8e506f1a1da185ee46685dd791f0efffd1";
  };
}
