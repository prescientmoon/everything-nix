# Configuration pieces included on all (nixos) hosts
{ inputs, outputs, ... }: {
  imports = [
    inputs.agenix.nixosModule
    # inputs.impermanence.nixosModule

    ./nix.nix
    ./openssh.nix
    ./fish.nix
    ./locale.nix
    ./wireless
  ];

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
