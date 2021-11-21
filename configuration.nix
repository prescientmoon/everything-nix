{ pkgs, lib, ... }: {
  imports = [ ./modules ];

  nixpkgs.config.allowBroken = true;
  boot.loader.systemd-boot.enable = true;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
      efiSysMountPoint = "/boot";
    };
    grub = {
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      # set $FS_UUID to the UUID of the EFI partition
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root $FS_UUID
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable sound.
  sound.enable = true;

  home-manager.users.adrielus = {
    manual.manpages.enable = false;
    # home.packages = with pkgs; [ bluez bluez-tools ];
  };

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

  system.stateVersion = "21.11";

  nixpkgs.config.allowUnfree = true;
}

