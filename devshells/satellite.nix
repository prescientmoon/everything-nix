{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    just
    python3
    sops
    ssh-to-age
    age
  ];
}
