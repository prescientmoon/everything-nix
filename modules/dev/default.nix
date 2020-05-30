{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [ gcc ];
  imports = [
    ./nix.nix
    ./purescript.nix
    ./javascript.nix
    ./fsharp.nix
    ./rust.nix
    ./haskell
  ];
}
