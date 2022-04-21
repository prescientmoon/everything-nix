{ pkgs, ... }:
{
  home-manager.users.adrielus.home = {
    file.".ghci".source = ./ghci;

    packages = with pkgs;
      [ ghc ghcid hlint cabal-install stack ]

      ++ (with haskellPackages; [ hoogle hpack ]);
  };
}
