{ config, ... }:
{
  imports = [
    ./aerc.nix
    ./accounts.nix
  ];

  programs.msmtp.enable = true; # SMTP client
  services.mbsync.enable = true; # email sync

  # Storage & persistence
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";
  satellite.persistence.at.data.apps.mail.directories = [
    config.accounts.email.maildirBasePath
  ];
}
