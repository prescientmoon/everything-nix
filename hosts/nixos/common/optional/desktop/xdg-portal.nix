{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.dbus.enable = true;
  environment.systemPackages = [ pkgs.xdg-utils ];
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-termfilechooser
    ];

    config.hyprland.default = "hyprland";
    config.hyprland."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    config.common.default = "hyprland";
    config.common."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
  };

  # Set up yazi as the default file picker
  # See: https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser
  environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI { } {
    filechooser =
      let
        deps = [ pkgs.yazi ];

        script = pkgs.stdenv.mkDerivation {
          inherit (pkgs.xdg-desktop-portal-termfilechooser) version;
          pname = "xdg-desktop-portal-termfilechooser-yazi-script";
          src = pkgs.xdg-desktop-portal-termfilechooser;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          buildPhase = ''
            runHook preBuild
            mkdir -p $out/bin
            cp $src/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh $out/bin/yazi-picker
            runHook postBuild
          '';

          postBuild = ''
            wrapProgram $out/bin/yazi-picker \
              --prefix PATH : ${lib.makeBinPath deps} \
              --set TERMCMD  '${lib.getExe pkgs.foot} -T "File picker"'
          '';

          meta.mainProgram = "yazi-picker";
        };
      in
      {
        cmd = lib.getExe script;
        default_dir = config.users.users.pilot.home;

        # What do these even do??
        open_mode = "suggested";
        save_mode = "last";
      };
  };
}
