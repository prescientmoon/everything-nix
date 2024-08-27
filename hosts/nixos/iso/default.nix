# See the wiki for more details https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
#
# Can be built with
# nix build .#nixosConfigurations.iso.config.system.build.isoImage
{
  modulesPath,
  inputs,
  pkgs,
  ...
}:
{
  # {{{ Imports
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops

    ../../../common
    ../common/global/wireless
    ../common/global/services/openssh.nix
    ../common/users/pilot.nix
    ../common/optional/desktop
    ../common/optional/wayland/hyprland.nix
    ../common/optional/services/kanata.nix
  ];
  # }}}
  # {{{ Automount hermes
  fileSystems."/hermes" = {
    device = "/dev/disk/by-uuid/7FE7-CA68";
    neededForBoot = true;
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };
  # }}}
  # {{{ Nix config
  nix = {
    # Flake support and whatnot
    package = pkgs.lix;

    # Enable flakes and new 'nix' command
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # }}}

  # Tell sops-nix to use the hermes keys for decrypting secrets
  sops.age.sshKeyPaths = [ "/hermes/secrets/hermes/ssh_host_ed25519_key" ];

  # Set username
  satellite.pilot.name = "moon";

  # Fast but bad compression
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
