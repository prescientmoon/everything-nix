{ pkgs, upkgs, ... }:
pkgs.mkShell {
  packages = [
    pkgs.just # script runner
    pkgs.python3 # used throughout a bunch of just recipes
    pkgs.sops # just sops-rekey
    pkgs.ssh-to-age # just ssh-to-age
    pkgs.age # just age-public-key
    upkgs.nixos-rebuild-ng
  ];
}
