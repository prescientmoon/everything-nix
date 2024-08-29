# Configuration pieces included on all (nixos) hosts
{
  inputs,
  lib,
  config,
  outputs,
  ...
}:
let
  # {{{ Imports
  imports = [
    # {{{ flake inputs
    inputs.disko.nixosModules.default
    inputs.stylix.nixosModules.stylix
    inputs.sops-nix.nixosModules.sops
    # }}}
    # {{{ global configuration
    ./cli/fish.nix
    ./services/openssh.nix
    ./nix.nix
    ./locale.nix
    ./unicode.nix
    ./persistence.nix
    ./ports.nix
    ./wireless

    ../../../../common
    # }}}
  ];
in
# }}}
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  # Tell sops-nix to use the host keys for decrypting secrets
  sops.age.sshKeyPaths = [ "/persist/state/etc/ssh/ssh_host_ed25519_key" ];

  # {{{ ad-hoc options
  # Customize tty colors
  stylix.targets.console.enable = true;

  # Reduce the amount of storage spent for logs
  services.journald.extraConfig = lib.mkDefault ''
    SystemMaxUse=256M
  '';

  # Boot using systemd
  boot.initrd.systemd.enable = true;
  # }}}
  # {{{ Disable sudo default lecture
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
  # }}}

  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays =
      builtins.attrValues outputs.overlays
      ++ lib.lists.optional config.satellite.toggles.neovim-nightly.enable inputs.neovim-nightly-overlay.overlay;

    config.allowUnfree = true;
  };

  # Root domain used throughout my config
  satellite.dns.domain = "moonythm.dev";
}
