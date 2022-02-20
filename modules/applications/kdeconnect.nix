{ pkgs, ... }: {
  home-manager.users.adrielus = {
    services.kdeconnect.enable = true;
  };

  # Open port for kdeconfig
  # networking.firewall.extraCommands = ''
  #   iptables -A nixos-fw -p tcp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept
  #   iptables -A nixos-fw -p udp --source 192.0.2.0/24 --dport 1714:1764 -j nixos-fw-accept
  # '';

  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
}
