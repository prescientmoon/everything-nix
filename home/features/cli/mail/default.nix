{ config, ... }:
{
  imports = [
    ./aerc.nix
    ./accounts.nix
  ];

  programs.msmtp.enable = true; # SMTP client
  programs.mbsync.enable = true;
  services.mbsync.enable = true;

  # Storage & persistence
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";
  satellite.persistence.at.data.apps.mail.directories = [
    config.accounts.email.maildirBasePath
  ];
}
