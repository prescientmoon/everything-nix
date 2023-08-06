{ inputs, ... }: {
  imports = [ inputs.grub2-themes.nixosModules.default ];

  boot.initrd.systemd.enable = true;

  # Defined [here](https://github.com/vinceliuice/grub2-themes/blob/master/flake.nix#L11)
  boot.loader.grub2-theme = {
    enable = true;
  };

  # See [the wiki page](https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows)
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
    };
  };
}
