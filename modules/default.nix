{ ... }: {
  imports = [
    ./dev
    ./applications
    ./theme
    ./overlays

    ./network.nix
    ./xserver.nix
    ./users.nix
    ./nix.nix
  ];
}
