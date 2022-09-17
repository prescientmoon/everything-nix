{ pkgs, lib, paths, ... }:
{
  home-manager.users.adrielus.services.polybar = {
    enable = true;
    extraConfig = ''
      ${pkgs.myThemes.current.polybar.config or ""}
      include-file = ${paths.dotfiles}/polybar/config.ini
    '';

    script = ''
      polybar main &
    '';
  };

  home-manager.users.adrielus.xsession = {
    enable = true;
    initExtra = ''
      polybar main &
    '';
  };
}
