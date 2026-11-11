{ config, lib, ... }:
let
  shared = {
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    BACKGROUND_COMPARISON = "yes";
  };
in
{
  # Why is this not part of the nixos module...
  systemd.tmpfiles.rules = lib.mapAttrsToList (
    _: c: "Q ${c.SUBVOLUME}/.snapshots"
  ) config.services.snapper.configs;

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    # http://snapper.io/manpages/snapper-configs.html
    configs = {
      data = shared // {
        SUBVOLUME = "/persist/data";

        TIMELINE_LIMIT_HOURLY = "24";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "12";
        TIMELINE_LIMIT_YEARLY = "0";
      };
      state = shared // {
        SUBVOLUME = "/persist/state";

        TIMELINE_LIMIT_HOURLY = "6";
        TIMELINE_LIMIT_DAILY = "3";
        TIMELINE_LIMIT_WEEKLY = "1";
        TIMELINE_LIMIT_MONTHLY = "1";
        TIMELINE_LIMIT_YEARLY = "0";
      };
    };
  };
}
