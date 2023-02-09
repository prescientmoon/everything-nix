# Configuration pieces included on all (nixos) hosts
{ inputs, outputs, lib, colorscheme, ... }:
let
  imports = [
    inputs.agenix.nixosModule
    inputs.base16.nixosModule
    # inputs.impermanence.nixosModule

    ./nix.nix
    ./openssh.nix
    ./fish.nix
    ./locale.nix
    ./wireless
  ];
in
{
  # Import all modules defined in modules/nixos
  imports = builtins.attrValues outputs.nixosModules ++ imports;

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  scheme = lib.mkDefault colorscheme;

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
