# This directory contains modules which can be loaded on both nixos and home-manager!
{
  imports = [
    ./fonts.nix
    ./themes
    ./nixpkgs.nix
  ];

  satellite.toggles.neovim-nightly.enable = true;
}
