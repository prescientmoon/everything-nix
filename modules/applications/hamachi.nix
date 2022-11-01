{ pkgs, ... }: {
  services.logmein-hamachi.enable = true;
  home-manager.users.adrielus.home.packages = [
    pkgs.logmein-hamachi
    pkgs.unstable.haguichi
  ];
}
