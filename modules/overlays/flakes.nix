{ system }:
{ home-manager

  # nixos stuff
, nixpkgs
, nixpkgs-unstable
, nixos-unstable

  # easy-*
, easy-purescript-nix
, easy-dhall-nix

  # fish plugins
, fish-plugin-z
, fish-theme-harleen
, fish-theme-agnoster
, fish-theme-dangerous

, oh-my-fish
, githubNvimTheme

  # vim plugins
, vim-plugin-arpeggio
, vim-plugin-kmonad

  # nvim plugins
, nvim-plugin-agda
, nvim-plugin-idris2

, telescope-file-browser-nvim # TODO: rename this one
, sddm-theme-chili
, ...
}: self: super:
# installs a vim plugin from git with a given tag / branch
let plugin = name: src: self.vimUtils.buildVimPluginFrom2Nix {
  inherit name;
  inherit src;
};
in
{
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  easy-purescript-nix = self.callPackage easy-purescript-nix { };
  easy-dhall-nix = self.callPackage easy-dhall-nix { };

  myFishPlugins = {
    inherit oh-my-fish;

    z = {
      src = fish-plugin-z;
      name = "z";
    };

    themes = {
      agnoster = {
        src = fish-theme-agnoster;
        name = "agnoster";
      };

      dangerous = {
        src = fish-theme-dangerous;
        name = "dangerous";
      };

      harleen = {
        src = fish-theme-harleen;
        name = "harleen";
      };
    };
  };


  # Vim plugins
  myVimPlugins = {
    githubNvimTheme = githubNvimTheme;

    telescope-file-browser-nvim = plugin "file_browser" telescope-file-browser-nvim;
    agda-nvim = plugin "agda" nvim-plugin-agda;
    idris2-nvim = plugin "idris" nvim-plugin-idris2;
    arpeggio = plugin "arpeggio" vim-plugin-arpeggio;
    kmonad-vim = plugin "kmonad-vim" vim-plugin-kmonad;
  };

  # a = fetchFromGitHub {
  #   repo = "kmonad-vim";
  #   owner = "kmonad";
  #   rev = "";
  #   sha256 = "";
  # };

  sddm-theme-chili = sddm-theme-chili;
}
