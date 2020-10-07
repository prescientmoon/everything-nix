{ pkgs, lib, ... }:
let sources = import ./nix/sources.nix;
in {
  imports = [ "${sources.home-manager}/nixos" ./modules ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable sound.
  sound.enable = true;

  # home-manager.users.adrielus.home.packages = with pkgs; [ bluez bluez-tools ];

  # Enable blueman
  # services.blueman.enable = true;

  hardware = {

    pulseaudio = {
      enable = true;

      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;

      # Extra codecs
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };

    #   configFile = pkgs.writeText "default.pa" ''
    #     load-module module-bluetooth-policy
    #     load-module module-bluetooth-discover
    #     ## module fails to load with 
    #     ##   module-bluez5-device.c: Failed to get device path from module arguments
    #     ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    #     # load-module module-bluez5-device
    #     # load-module module-bluez5-discover
    #   '';

    #   extraConfig = ''
    #     load-module module-switch-on-connect
    #   '';
    # };
    # bluetooth = {
    #   enable = true;
    #   config."General"."Enable" = "Source,Sink,Media,Socket";

    # };
  };

  # home-manager.users.adrielus.services.mpris-proxy = {
  #   Unit.Description = "Mpris proxy";
  #   Unit.After = [ "network.target" "sound.target" ];
  #   Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  #   Install.WantedBy = [ "default.target" ];
  # };
  system.stateVersion = "20.03";
}

