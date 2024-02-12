{ config, ... }: {
  imports = [ ./msmtp.nix ];

  # {{{ Zfs config 
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;

    zed = {
      enableMail = true;
      settings = {
        ZED_EMAIL_ADDR = [ "colimit@moonythm.dev" ];
        ZED_EMAIL_PROG = "sendmail";
        ZED_EMAIL_OPTS = "-a zed @ADDRESS@";
      };
    };
  };
  # }}}
  # {{{ Sanoid config 
  # Sanoid allows me to configure snapshot frequency on a per-dataset basis.
  services.sanoid = {
    enable = true;

    # {{{ Data
    datasets."zroot/root/persist/data" = {
      autosnap = true;
      autoprune = true;
      recursive = true;
      yearly = 0;
      monthly = 12;
      weekly = 4;
      daily = 7;
      hourly = 24;
    };
    # }}}
    # {{{ State
    datasets."zroot/root/persist/state" = {
      autosnap = true;
      autoprune = true;
      recursive = true;
      yearly = 0;
      monthly = 1;
      weekly = 1;
      daily = 3;
      hourly = 6;
    };
    # }}}
  };
  # }}}
  # {{{ Zed email config
  # Zed allows using email notifications for events
  sops.secrets.zed_smtp_pass.sopsFile = ../secrets.yaml;
  programs.msmtp.accounts.zed = {
    from = "zed@orbit.moonythm.dev";
    user = "zed@orbit.moonythm.dev";
    passwordeval = "cat ${config.sops.secrets.zed_smtp_pass.path}";
  };
  # }}}
}
