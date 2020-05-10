{ pkgs, lib, ... }:
let sources = import ./nix/sources.nix;
in {
  imports = [ "${sources.home-manager}/nixos" ./modules ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  system.stateVersion = "20.03";
}

