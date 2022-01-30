{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ./tweakSources.nix)
    # neovim with my own config baked in
    (import ./neovim.nix)
  ];
}
