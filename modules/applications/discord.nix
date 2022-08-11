{ pkgs, ... }: {
  home-manager.users.adrielus = {
    xdg.configFile."discord/settings.json".text = '' 
      {
        "BACKGROUND_COLOR": "#ffffff",
        "SKIP_HOST_UPDATE": true
      }
    '';
    home.packages = with pkgs; [
      unstable.discord
    ];
  };
}
