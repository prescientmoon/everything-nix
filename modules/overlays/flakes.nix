{ system }:
{ home-manager
  # nixos stuff
, nixpkgs
, nixpkgs-unstable
, nixos-unstable
, ...
}: self: super:
let
  foreign = self.callPackage (import ../foreign.nix) { };
in
{
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  nixos-unstable = import nixos-unstable {
    inherit system;
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  easy-purescript-nix = self.callPackage foreign.easy-purescript-nix { };
  easy-dhall-nix = self.callPackage foreign.easy-dhall-nix { };

  myFishPlugins = {
    oh-my-fish = foreign.fishPlugins.oh-my-fish;

    z = {
      src = foreign.fishPlugins.z;
      name = "z";
    };

    themes = {
      agnoster = {
        src = foreign.fishPlugins.themes.agnoster;
        name = "agnoster";
      };

      dangerous = {
        src = foreign.fishPlugins.themes.dangerous;
        name = "dangerous";
      };

      harleen = {
        src = foreign.fishPlugins.themes.harleen;
        name = "harleen";
      };
    };
  };


  # Vim plugins
  myVimPlugins = {
    githubNvimTheme = foreign.githubNvimTheme;
  };

  sddm-theme-chili = foreign.sddm-theme-chili;
}
