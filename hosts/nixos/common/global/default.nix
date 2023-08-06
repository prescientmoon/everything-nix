# Configuration pieces included on all (nixos) hosts
{ inputs, outputs, ... }:
let
  imports = [
    inputs.hyprland.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix
    inputs.nur.nixosModules.nur
    inputs.impermanence.nixosModule
    inputs.slambda.nixosModule

    ./persistence.nix
    ./nix.nix
    ./openssh.nix
    ./fish.nix
    ./locale.nix
    ./wireless
    # ./tailscale.nix
    ../../../../common
  ];
in
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  # Allow non root users to specify the "allowOther" option.
  # See [the imperanence readme](https://github.com/nix-community/impermanence#home-manager)
  programs.fuse.userAllowOther = true;

  # Customize tty colors
  stylix.targets.console.enable = true;

  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays = builtins.attrValues outputs.overlays ++ [
      inputs.neovim-nightly-overlay.overlay
    ];

    config = {
      allowUnfree = true;
    };
  };
}
