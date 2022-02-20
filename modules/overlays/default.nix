{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ./tweakSources.nix)
    (import ./npm.nix)

    # I hope this works (spoiler: it did not)
    # (import ./edopro)
  ];
}
