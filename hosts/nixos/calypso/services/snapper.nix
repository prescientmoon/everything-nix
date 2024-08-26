{
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    # http://snapper.io/manpages/snapper-configs.html
    configs = {
      # {{{ Data
      data = {
        SUBVOLUME = "/root/persist/data";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        BACKGROUND_COMPARISON = "yes";

        TIMELINE_LIMIT_HOURLY = "24";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "12";
        TIMELINE_LIMIT_YEARLY = "0";
      };
      # }}}
      # {{{ State
      state = {
        SUBVOLUME = "/root/persist/state";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        BACKGROUND_COMPARISON = "yes";

        TIMELINE_LIMIT_HOURLY = "6";
        TIMELINE_LIMIT_DAILY = "3";
        TIMELINE_LIMIT_WEEKLY = "1";
        TIMELINE_LIMIT_MONTHLY = "1";
        TIMELINE_LIMIT_YEARLY = "0";
      };
      # }}}
    };
  };
}
