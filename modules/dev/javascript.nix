{ pkgs, ... }:
let fromNpm = import ./npm { inherit pkgs; };
in {
  home-manager.users.adrielus.home.packages = with pkgs;
    with nodePackages;
    with fromNpm; [
      nodejs
      node2nix

      pnpm
      yarn
    ];
}
