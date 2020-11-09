{ pkgs, ... }: {
  # 32 bit stuff
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  home-manager.users.adrielus.home.packages = with pkgs; [ steam ];
}
