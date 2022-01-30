{ system }:
{ home-manager, nixpkgs, nixpkgs-unstable, nixos-unstable, easy-purescript-nix
, easy-dhall-nix, z, agnoster, githubNvimTheme, vim-extra-plugins, ... }:
(self: super: {
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
})
