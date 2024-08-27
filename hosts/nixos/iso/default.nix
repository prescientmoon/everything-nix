{ modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    ../common/global
    ../common/optional/wayland/hyprland.nix
  ];

  # Tell sops-nix to use the hermes keys for decrypting secrets
  sops.age.sshKeyPaths = [ "/hermes/secrets/hermes/ssh_host_ed25519_key" ];

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
}
