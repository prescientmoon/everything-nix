# Shell for bootstrapping flake-enabled nix and home-manager
{ pkgs ? (import ./nixpkgs.nix) { }, ... }:
pkgs.mkShell {
  # Enable experimental features without having to specify the argument
  NIX_CONFIG = "experimental-features = nix-command flakes";
  packages = with pkgs; [ nix home-manager git ];
}
