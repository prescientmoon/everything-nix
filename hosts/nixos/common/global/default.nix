# Configuration pieces included on all (nixos) hosts
{ inputs, outputs, lib, ... }:
let
  imports = [
    inputs.agenix.nixosModule
    inputs.stylix.nixosModules.stylix
    inputs.slambda.nixosModule
    inputs.nur.nixosModules.nur
    inputs.impermanence.nixosModule

    ./nix.nix
    ./openssh.nix
    ./fish.nix
    ./locale.nix
    ./wireless
    ../../../../common
  ];
in
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  # Allow non root users to specify the "allowOther" option.
  # See [the imperanence readme](https://github.com/nix-community/impermanence#home-manager)
  programs.fuse.userAllowOther = true;

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
