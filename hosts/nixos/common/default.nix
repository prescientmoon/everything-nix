# Configuration pieces included on all (nixos) hosts
{
  config,
  inputs,
  lib,
  outputs,
  ...
}:
let
  imports = [
    # Flake inputs
    inputs.disko.nixosModules.default
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops

    # Other satellite inputs
    ../../../dns/implementation/nixos-module.nix
    ../../../dns/implementation/nixos-module-assertions.nix
    ../../../common

    # Global configuration
    ./base
    ./cli
    ./nix.nix
    ./desktop
    ./wireless
    ./persistence.nix
    ./networking.nix
    ./users/pilot.nix

    # Services
    ./services/acme.nix
    ./services/greetd.nix
    ./services/kanata
    ./services/mullvad.nix
    ./services/nginx.nix
    ./services/oci.nix
    ./services/openssh.nix
    ./services/postgres.nix
    ./services/qbittorrent.nix
    ./services/restic
    ./services/syncthing.nix
    ./services/tailscale.nix
    ./services/wireguard
  ];
in
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  # Tell sops-nix to use the host keys for decrypting secrets
  sops.age.sshKeyPaths = [ "/persist/state/etc/ssh/ssh_host_ed25519_key" ];

  # Reduce the amount of storage spent for logs
  services.journald.extraConfig = lib.mkDefault ''
    SystemMaxUse=256M
  '';

  # Boot using systemd
  boot.initrd.systemd.enable = true;

  # Customize TTY colors
  stylix.targets.console.enable = lib.mkIf config.satellite.machine.interactible true;

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Amsterdam";

  # Root domain used throughout my config
  satellite.dns.domain = lib.mkDefault "moonythm.dev";
}
