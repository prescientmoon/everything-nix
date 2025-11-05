{ config, ... }:
{
  sops.secrets.moonythm_mail_pass.sopsFile = ../../../secrets.yaml;

  accounts.email.accounts = {
    moonythm = rec {
      address = "colimit@moonythm.dev";
      realName = "prescientmoon";
      userName = address;
      aliases = [
        "hi@moonythm.dev"
        "psy@moonythm.dev"
      ];

      folders = {
        inbox = "Inbox";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
      };

      passwordCommand = "cat ${config.sops.secrets.moonythm_mail_pass.path}";
      primary = true;

      # IMAP / SMTP configuration
      imap.host = "imap.migadu.com";
      imap.port = 993;
      smtp.host = "smtp.migadu.com";
      smtp.port = 465;

      aerc.enable = true;
      msmtp.enable = true;

      # Email sync to the local maildir
      mbsync = {
        enable = true;
        create = "both"; # sync folders both ways
        expunge = "maildir"; # Delete messages when the local directory says so
      };
    };
  };
}
