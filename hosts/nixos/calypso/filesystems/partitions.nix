{
  disks ? [ "/dev/nvme0n1" ],
  ...
}:
{
  disko.devices.disk.main = {
    type = "disk";
    device = builtins.elemAt disks 0;
    content = {
      type = "gpt";
      partitions = {
        # {{{ Boot
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "defaults" ];
          };
        };
        # }}}
        # {{{ Luks
        luks = {
          size = "384G"; # The remaining space is left for windows
          content = {
            type = "luks";
            name = "crypted";
            passwordFile = "/hermes/secrets/calypso/disk.key";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                # {{{ /blank
                "/blank" = { };
                # }}}
                # {{{ /root
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # }}}
                # {{{ /swap
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "20G";
                };
                # }}}
                # {{{ /root/persist/data
                "/root/persist/data" = {
                  mountpoint = "/persist/data";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # }}}
                # {{{ /root/persist/state
                "/root/persist/state" = {
                  mountpoint = "/persist/state";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # }}}
                # {{{ /root/local/nix
                "/root/local/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # }}}
                # {{{ /root/local/cache
                "/root/local/cache" = {
                  mountpoint = "/persist/local/cache";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # }}}
              };
            };
          };
        };
        # }}}
      };
    };
  };
}
