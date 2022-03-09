{ system }:
{ home-manager
, nixpkgs
, nixpkgs-unstable
, nixos-unstable
, easy-purescript-nix
, easy-dhall-nix
, fish-plugin-z
, fish-theme-harleen
, fish-theme-agnoster
, fish-theme-dangerous
, oh-my-fish
, githubNvimTheme
, vim-extra-plugins
, telescope-file-browser-nvim
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

  githubNvimTheme = githubNvimTheme;

  # Vim plugins
  myVimPlugins = {
    telescope-file-browser-nvim =
      plugin "file_browser" telescope-file-browser-nvim;
  };
}
