{ config, ... }: {
  imports = [ ./msmtp.nix ];

  # {{{ Zfs config 
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;

    autoSnapshot = {
      enable = true;

      # -k -p is the default, and --utc is there to prevent timezone-related issues
      autoSnapshot.flags = "-k -p --utc";
    };

    # zed.enableMail = true;
  };
  # }}}
  # {{{ Zed email config
  sops.secrets.zed_smtp_pass.sopsFile = ../secrets.yaml;
  programs.msmtp.accounts.zed = {
    from = "zed@orbit.moonythm.dev";
    user = "zed@orbit.moonythm.dev";
    passwordeval = "cat ${config.sops.secrets.zed_smtp_pass.path}";
  };
  # }}}
}
