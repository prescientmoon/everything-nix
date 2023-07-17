{ disks ? [ "/dev/vdb" ], ... }: {
  disko.devices = {
    # {{{ Disks
    disk = {
      vdb = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "0MiB";
              end = "64MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            }
            {
              name = "zfs";
              start = "128MiB";
              end = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            }
          ];
        };
      };
    };
    # }}}
    # {{{ zpools
    zpool = {
      zroot = {
        type = "zpool";
        mountpoint = "/";

        postCreateHook = ''
          zfs snapshot zroot@blank
          zfs set keylocation="prompt" "zroot";
        '';

        rootFsOptions = {
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/secret.key";
        };

        # {{{ Datasets
        datasets = {
          "root/persist/data" = {
            type = "zfs_fs";
            mountpoint = "/persist/data";
            options."com.sun:auto-snapshot" = "true";
          };
          "root/persist/state" = {
            type = "zfs_fs";
            mountpoint = "/persist/state";
            options."com.sun:auto-snapshot" = "true";
          };
          "root/local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "root/local/cache" = {
            type = "zfs_fs";
            mountpoint = "/persist/local/cache";
          };
        };
        # }}}
      };
    };
    # }}}
  };
}
