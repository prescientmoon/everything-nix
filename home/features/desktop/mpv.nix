{ pkgs, ... }:
{
  home.packages = [ pkgs.mpv ];
  xdg.configFile."mpv/mpv.conf".text = ''
    # Fullscreen hardly works otherwise.
    gpu-api=opengl
  '';
}
