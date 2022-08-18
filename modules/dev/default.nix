{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [ gcc ];
  imports = [
    ./nix.nix
    ./purescript.nix
    ./javascript.nix
    ./rust.nix
    ./dhall.nix
    ./haskell
    ./fsharp.nix
    ./kotlin.nix
    # ./racket.nix
    # ./elm.nix

    # Proof assistants
    # ./agda.nix
    # ./idris.nix
    ./lean.nix
  ];
}
