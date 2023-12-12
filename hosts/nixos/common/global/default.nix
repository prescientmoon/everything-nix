# Configuration pieces included on all (nixos) hosts
{ inputs, lib, config, outputs, ... }:
let
  # {{{ Imports
  imports = [
    # {{{ flake inputs 
    # inputs.hyprland.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix
    inputs.nur.nixosModules.nur
    inputs.slambda.nixosModule

    # {{{ self management 
    # NOTE: using `pkgs.system` before `module.options` is evaluated
    # leads to infinite recursion!
    inputs.intray.nixosModules.x86_64-linux.default
    inputs.smos.nixosModules.x86_64-linux.default
    inputs.tickler.nixosModules.x86_64-linux.default
    # }}}
    # }}}
    # {{{ global configuration
    ./cli/fish.nix
    ./cli/htop.nix
    ./services/openssh.nix
    ./services/tailscale.nix
    ./nix.nix
    ./locale.nix
    ./persistence.nix
    ./wireless

    ../../../../common
    # }}}
  ];
  # }}}
in
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  # {{{ ad-hoc options
  # Customize tty colors
  stylix.targets.console.enable = true;

  # Reduce the amount of storage spent for logs
  services.journald.extraConfig = lib.mkDefault ''
    SystemMaxUse=256M
  '';
  # }}}

  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays = builtins.attrValues outputs.overlays ++
      lib.lists.optional
        config.satellite.toggles.neovim-nightly.enable
        inputs.neovim-nightly-overlay.overlay;

    config.allowUnfree = true;
  };
}
