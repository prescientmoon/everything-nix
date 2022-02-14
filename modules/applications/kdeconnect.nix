{ pkgs, ... }: {
  home-manager.users.adrielus = {
    services.kdeconnect.enable = true;
  };
}
