{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (import ./tweakSources.nix)
    (import ./npm.nix)
    ((import ./myPackages.nix) {
      inherit lib;
    }) # Requires lib access
    (import ./vimclip)

    # I hope this works (spoiler: it did not)
    # (import ./edopro)
  ];
}
