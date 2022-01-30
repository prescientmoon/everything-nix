{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ./tweakSources.nix)

    # I hope this works
    (import ./edopro)

  ];
}
