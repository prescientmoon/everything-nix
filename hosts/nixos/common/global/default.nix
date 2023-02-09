# Configuration pieces included on all (nixos) hosts
{ inputs, outputs, lib, colorscheme, ... }: {
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
