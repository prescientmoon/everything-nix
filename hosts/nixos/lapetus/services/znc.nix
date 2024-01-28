{ ... }: {
  services.znc = {
    enable = true;
    # mutable = false;
    configOptions = {
      nick = "prescientmoon";
      networks.tilde = {
        server = "eu.tilde.chat";
        port = 6697;
        channels = [ "#meta" "#math" ];
        modules = [
          "simple_away" # marks me as away when disconnected
          "sasl" # auto login
        ];
      };
    };
  };
}
