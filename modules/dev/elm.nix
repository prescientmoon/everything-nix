{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs;
    with elmPackages; [
      elm
      elm-format
      # elm-repl
    ];
}
