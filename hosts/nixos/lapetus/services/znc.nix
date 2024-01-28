{ ... }: {
  services.znc = {
    enable = true;
    # mutable = false;
    useLegacyConfig = false;

    config.User.prescientmoon = {
      Network.tilde = {
        Server = "eu.tilde.chat +6697";
        Chan."#meta" = { };
        Chan."#math" = { };
        Nick = "prescientmoon";
        LoadModule = [ "" ];
        JoinDelay = 2; # Avoid joining channels before auth
      };
    };
  };
}
