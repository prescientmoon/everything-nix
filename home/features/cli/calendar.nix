# Despite its name, this file handles both contacts and calendars.
{ config, ... }:
let
  cal = config.accounts.calendar.accounts.moonythm-calendar;
  con = config.accounts.contact.accounts.moonythm-contacts;
in
{
  sops.secrets.moonythm_cal_pass.sopsFile = ../../secrets.yaml;

  programs.khard.enable = true;
  programs.pimsync.enable = true;
  services.pimsync.enable = true;

  programs.khal = {
    enable = true;
    settings.default.default_calendar = "Main";
  };

  satellite.persistence.at.data.apps = {
    calendar.directories = [ config.accounts.calendar.basePath ];
    contact.directories = [ config.accounts.contact.basePath ];
  };

  systemd.user.tmpfiles.rules = [
    "d ${cal.local.path}"
    "d ${con.local.path}"
  ];

  satellite.persistence.at.state.apps = {
    calendar.directories = [ "${config.xdg.dataHome}/pimsync" ];
  };

  accounts.calendar.basePath = "${config.xdg.dataHome}/calendars";
  accounts.calendar.accounts.moonythm-calendar = {
    pimsync = {
      enable = true;
      extraPairDirectives = [
        {
          name = "collections";
          params = [ "all" ];
        }
      ];
    };

    remote = {
      type = "caldav";
      url = "https://cal.moonythm.dev/prescientmoon/dfff0259-a4ca-6138-63e9-4c5474557ece/";
      userName = "prescientmoon";
      passwordCommand = [
        "cat"
        config.sops.secrets.moonythm_cal_pass.path
      ];
    };

    khal = {
      enable = true;
      type = "discover";
      addresses = [ "hi@moonythm.dev" ];
    };
  };

  accounts.contact.basePath = "${config.xdg.dataHome}/contact";
  accounts.contact.accounts.moonythm-contacts = {
    pimsync = {
      enable = true;
      inherit (cal.pimsync) extraPairDirectives;
    };

    remote = {
      type = "carddav";
      url = "https://cal.moonythm.dev/prescientmoon/d68f5f94-f30e-4126-8b35-89209721b886/";
      inherit (cal.remote) userName passwordCommand;
    };

    khal = {
      enable = true;
      inherit (cal.khal) addresses;
    };

    khard = {
      enable = true;
      type = "discover";
    };
  };
}
