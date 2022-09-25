{ fetchFromGitHub, ... }: {
  vimPlugins = {
    kmonad = fetchFromGitHub {
      owner = "kmonad";
      repo = "kmonad-vim";
      rev = "37978445197ab00edeb5b731e9ca90c2b141723f";
      sha256 = "13p3i0b8azkmhafyv8hc4hav1pmgqg52xzvk2a3gp3ppqqx9bwpc";
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
        rev = "c142e802983bd1b34b4d91efac2126fc5913126d";
        sha256 = "060yydkxmvmlzq2236pjqfmpgvm3g1085c5yzilq0nl1dvmz3wnh";
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
    rev = "3d8b602e80c0fa7d97d7f03cb8e2f8b06967d509";
    sha256 = "0kvnsc4j0h8qvv69613781i2qy51rcbmv5ga8j21nsqzy3l8fd9w";
  };

  githubNvimTheme = fetchFromGitHub {
    owner = "projekt0n";
    repo = "github-nvim-theme";
    rev = "b3f15193d1733cc4e9c9fe65fbfec329af4bdc2a";
    sha256 = "0vnizbmzf42h3idm35nrcv4g2aigvgmgb80qk5s4xq1513bzrdf0";
  };
}
