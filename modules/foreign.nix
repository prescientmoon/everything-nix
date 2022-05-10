{ fetchFromGitHub, ... }: {
  vimPlugins = {
    kmonad = fetchFromGitHub {
      owner = "kmonad";
      repo = "kmonad-vim";
      rev = "37978445197ab00edeb5b731e9ca90c2b141723f";
      sha256 = "13p3i0b8azkmhafyv8hc4hav1pmgqg52xzvk2a3gp3ppqqx9bwpc";
    };

    arpeggio = fetchFromGitHub {
      owner = "kana";
      repo = "vim-arpeggio";
      rev = "37978445197ab00edeb5b731e9ca90c2b141723f";
      sha256 = "13p3i0b8azkmhafyv8hc4hav1pmgqg52xzvk2a3gp3ppqqx9bwpc";
    };

    agda-nvim = fetchFromGitHub {
      owner = "Isti115";
      repo = "agda.nvim";
      rev = "c7da627547e978b4ac3780af1b8f418c8b12ff98";
      sha256 = "0k9g0bqm1a4ivl4cs6f780nnjnc8svc1kqif4l4ahsfzasnj7dbk";
    };

    idris2-nvim = fetchFromGitHub {
      owner = "ShinKage";
      repo = "idris2-nvim";
      rev = "fdc47ba6f0e9d15c2754ee98b6455acad0fa7c95";
      sha256 = "1kzbgmxpywpinrjdrb4crxwlk3jlck3yia2wbl0rq7xwfga663g4";
    };

    telescope-file-browser-nvim = fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope-file-browser.nvim";
      rev = "ee355b83e00475e11dec82e3ea166f846a392018";
      sha256 = "1s39si5fifv6bvjk8kzs2zy18ap5q22pfqg68wn5icnp588498hz";
    };
  };
  fishPlugins = {
    z = fetchFromGitHub {
      owner = "jethrokuan";
      repo = "z";
      rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
      sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
    };

    themes = {
      agnoster = fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-agnoster";
        rev = "1ffca413bfbc8941c28982eea97c1e1fa3612d57";
        sha256 = "1dvws7mrz8shca6lmnanz72zm7b2cnhg549in655inw0rk9hcbma";
      };

      harleen = fetchFromGitHub {
        owner = "aneveux";
        repo = "theme-harleen";
        rev = "caf53d792038e78faa7b6b6b98669abc171c5e64";
        sha256 = "1450qrkdmqxk686c7vpimcydwj9z9a7w7sripfpjzkq6np5s6w8c";
      };

      dangerous = fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-dangerous";
        rev = "3cdfc82060ba280b44f1f0c6616675f36a275467";
        sha256 = "1xxy0b6rnvsfbaa6v7p0fsxi8l161sv4fq49ahra2hf5gzax4xis";
      };
    };

    oh-my-fish = fetchFromGitHub {
      owner = "oh-my-fish";
      repo = "oh-my-fish";
      rev = "d428b723c8c18fef3b2a00b8b8b731177f483ad8";
      sha256 = "0n5a8v9kn4xmmi7app6c4wvpjfv6b3vhj7rhljaf9vny8cl2vhls";
    };
  };

  sddm-theme-chili = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
  };

  easy-dhall-nix = fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-dhall-nix";
    rev = "dce9acbb99776a7f1344db4751d6080380f76f57";
    sha256 = "0ckp6515gfvbxm08yyll87d9vg8sq2l21gwav2npzvwc3xz2lccf";
  };

  easy-purescript-nix = fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "0ad5775c1e80cdd952527db2da969982e39ff592";
    sha256 = "0x53ads5v8zqsk4r1mfpzf5913byifdpv5shnvxpgw634ifyj1kg";
  };

  githubNvimTheme = fetchFromGitHub {
    owner = "projekt0n";
    repo = "github-nvim-theme";
    rev = "eeac2e7b2832d8de9a21cfa8627835304c96bb44";
    sha256 = "1rfxif39y42amkz772976l14dnsa9ybi2dpkaqbdz7zvwgwm545m";
  };
}
