{ system }:
{ home-manager
, nixpkgs
, nixpkgs-unstable
, nixos-unstable
, easy-purescript-nix
, easy-dhall-nix
, z
, agnoster
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

  z = {
    src = z;
    name = "z";
  };

  agnoster = {
    src = agnoster;
    name = "agnoster";
  };

  githubNvimTheme = githubNvimTheme;

  # Vim plugins
  myVimPlugins = {
    telescope-file-browser-nvim =
      plugin "file_browser" telescope-file-browser-nvim;
  };
}
