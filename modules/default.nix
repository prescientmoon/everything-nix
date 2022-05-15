{ ... }: {
  imports = [
    ./dev
    ./applications
    ./themes
    ./overlays
    ./meta

    ./network.nix
    ./xserver.nix
    ./users.nix
    ./nix.nix
    ./printers.nix
    # ./bluetooth.nix
  ];
}
