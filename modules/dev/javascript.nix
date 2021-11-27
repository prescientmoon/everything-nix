{ pkgs, ... }:
let
  # fromNpm = import ./npm { inherit pkgs; };
  node = pkgs.nodejs-12_x;
  yarn = pkgs.yarn.override { nodejs = node; };
in {
  home-manager.users.adrielus.home.packages = with pkgs;
    with nodePackages;
    # with fromNpm;
    [
      node
      deno
      node2nix

      pnpm
      yarn

      /* tsdx
            mklicense
            preact-cli
            create-next-app
            create-snowpack-app
            bower
      */
    ];
}
