# See the wiki for more details https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
#
# Can be built with
# nix build .#nixosConfigurations.iso.config.system.build.isoImage
{ modulesPath, lib, ... }:
{
  # {{{ Imports
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    ../common/global
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

  # Tell sops-nix to use the hermes keys for decrypting secrets
  sops.age.sshKeyPaths = [ "/hermes/secrets/hermes/ssh_host_ed25519_key" ];

  # Override tailscale service enabled by the `global/default.nix` file
  services.tailscale.enable = lib.mkForce false;

  # Fast but bad compression
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Set username
  satellite.pilot.name = "moon";
}
