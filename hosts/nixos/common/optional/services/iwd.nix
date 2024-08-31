{
  networking.wireless.iwd = {
    enable = true;

    settings = {
      IPv6.Enabled = true;
      Settings.AutoConnect = true;
    };
  };

  environment.persistence."/persist/state".directories = [ "/var/lib/iwd" ];
}
