{ pkgs, ... }: {
  home-manager.users.adrielus.home = {
    file.".wakatime.cfg".source = ./wakatime.cfg;
    packages = with pkgs; [ wakatime ];
  };
}
