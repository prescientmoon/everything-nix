{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/xmonad.nix
  ];
}
