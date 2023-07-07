{ lib, ... }: {
  services.gitea = {
    enable = true;
    appName = "pinktea";
    stateDir = "/persist/state/pinktea";
    lfs.enable = true;

    dump = {
      enable = true;
      type = "tar.gz";
    };

    # See [the cheatsheet](https://docs.gitea.com/next/administration/config-cheat-sheet)
    settings = {
      session.COOKIE_SECURE = false; # TODO: set to true when serving over https
      repository = {
        DISABLED_REPO_UNITS = "";
        DEFAULT_REPO_UNITS = lib.strings.concatStringsSep "," [
          "repo.code"
          "repo.releases"
          "repo.issues"
          "repo.pulls"
        ];
        DISABLE_STARS = true;
      };
    };
  };
}
