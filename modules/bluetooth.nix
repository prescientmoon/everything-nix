# Taken from https://nixos.wiki/wiki/Bluetooth
{ pkgs, ... }: {
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;

  # TODO: investigate why this does not work
  # systemd.user.services.mpris-proxy = {
  #   Unit.Description = "Mpris proxy";
  #   Unit.After = [ "network.target" "sound.target" ];
  #   Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  #   Install.WantedBy = [ "default.target" ];
  # };

  hardware = {
    pulseaudio = {
      enable = true;

      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;

      # Extra codecs
      extraModules = [ pkgs.pulseaudio-modules-bt ];

      configFile = pkgs.writeText "default.pa" ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
        ## module fails to load with 
        ##   module-bluez5-device.c: Failed to get device path from module arguments
        ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
        # load-module module-bluez5-device
        # load-module module-bluez5-discover
      '';

      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };
}
