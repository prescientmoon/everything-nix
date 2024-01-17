{ config, pkgs, ... }: {
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  boot.initrd.systemd.services =
    let secretMountpoint = "/hermes";
    in
    {
      # {{{ Mount usb 
      mountSecrets = {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig.DefaultDependencies = "no";
        wantedBy = [ "initrd.target" ];
        before = [ "zfs-mount.service" ];
        after = [ "zfs-import.target" ];
        script = ''
          MOUNTPOINT="${secretMountpoint}"
          USB="/dev/sdb"

          echo "Waiting for $USB"
          for I in {1..20}; do
              if [ -e "$USB" ]; then break; fi
              echo -n .
              sleep 1
          done

          echo "Found $USB"
          sleep 1

          if [ -e "$USB" ]; then
              echo "Mounting $USB"
              mkdir -p $MOUNTPOINT
              mount -o ro "$USB" $MOUNTPOINT
              if [ $? -eq 0 ]; then
                  exit 0
              else
                  echo "Error mounting $USB" >&2
              fi
          else
              echo "Cannot find $USB" >&2
          fi
        '';
      };
      # }}}
      # {{{ Unmount usb 
      unmountSecrets = {
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig.DefaultDependencies = "no";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-mount.service" ];
        script = ''
          MOUNTPOINT="${secretMountpoint}"
          if [ -e "$MOUNTPOINT" ]; then
              echo "Clearing $MOUNTPOINT"
              umount $MOUNTPOINT
              rmdir $MOUNTPOINT
              echo "Unmounted $MOUNTPOINT"
          else
              echo "Nothing to unmount"
          fi
        '';
      };
      # }}}
      # # {{{ Rollback 
      # rollback = {
      #   path = [ pkgs.zfs ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     RemainAfterExit = true;
      #   };
      #   unitConfig.DefaultDependencies = "no";
      #   wantedBy = [ "initrd.target" ];
      #   after = [ "zfs-import.target" ];
      #   before = [ "sysroot.mount" ];
      #   script = "zfs rollback -r zroot@blank";
      # };
      # # }}}
    };
}
