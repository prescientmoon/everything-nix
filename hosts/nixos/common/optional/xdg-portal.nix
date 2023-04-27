{ pkgs, lib, ... }: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # HACK: copied from @lily on discord.
  systemd.user.services.xdg-desktop-portal.path = lib.mkAfter [ "/run/current-system/sw" ];
}
