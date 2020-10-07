{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs.easy-purescript-nix; [
    purescript
    spago
    purty
    pscid
    pulp
    zephyr
  ];
}
