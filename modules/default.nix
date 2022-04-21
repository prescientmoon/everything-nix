{ ... }: {
  imports = [
    ./dev
    ./applications
    ./themes
    ./overlays

    ./network.nix
    ./xserver.nix
    ./users.nix
    ./nix.nix
    ./printers.nix
    # ./bluetooth.nix
  ];
}
