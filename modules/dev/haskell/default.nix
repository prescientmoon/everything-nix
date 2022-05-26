{ pkgs, ... }:
{
  # Use more recent ghc versions
  # nixpkgs.overlays = [
  #   (self: super: {
  #     haskell.compiler.ghc902 = self.unstable.haskell.compiler.ghc902;
  #   })
  # ];

  home-manager.users.adrielus.home = {
    file.".ghci".source = ./ghci;

    packages = with pkgs;
      [ ghc ghcid hlint cabal-install stack ]

      ++ (with haskellPackages; [ hoogle hpack ]);
  };
}
