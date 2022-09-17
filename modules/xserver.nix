{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  environment.systemPackages = with pkgs; [
    # Required for the sddm theme
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtbase
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    xkbOptions = "eurosign:e";

    # Make the xmonad session the default
    # displayManager.defaultSession = "none+xmonad";
    displayManager = {
      defaultSession = "none+xmonad";
      sddm = {
        enable = true;
        theme = theme.sddm.path;
      };

      autoLogin = {
        enable = true;
        user = "adrielus";
      };
    };

    # displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;


    # Enable xmonad
    windowManager.xmonad.enable = true;

    libinput = {
      # Enable touchpad support.
      enable = true;

      touchpad = {
        naturalScrolling = true;
        accelSpeed = "3.5";

        tappingDragLock = false;
        disableWhileTyping = true;
      };
    };
  };

  # I think this has to do with multiple monitors and stuff?
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  services.fractalart.enable = true;
  hardware.opengl.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    # gnome-photos
    # gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
}
