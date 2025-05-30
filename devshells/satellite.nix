{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    just
    sops
    ssh-to-age
  ];
}
