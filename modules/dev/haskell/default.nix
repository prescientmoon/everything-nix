{ pkgs, ... }:
let hie = pkgs.all-hies.selection { selector = p: { inherit (p) ghc865; }; };
in {
  home-manager.users.adrielus.home = {
    file.".ghci".source = ./ghci;

    packages = with pkgs;
      [ ghc ghcid hlint cabal-install snack stack hie ]
      ++ (with haskellPackages; [ brittany hoogle hpack pointfree ]);
  };
}
