{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs.unstable; [
    purescript
    spago
    # haskellPackages.zephyr
    # purty # purescript formatter
    # purs-tidy # purescript formatter
    # pscid
    # pulp
    # psa
  ];
}
