{
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    accounts = {
      defaults = {
        auth = true;
        tls = true;
        host = "smtp.migadu.com";
        port = 465;
      };
    };
  };
}
