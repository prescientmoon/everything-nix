{ pkgs, ... }: {
  home-manager.users.adrielus = {
    services.kdeconnect.enable = true;
  };

  # Open port for kdeconnect
  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
}
