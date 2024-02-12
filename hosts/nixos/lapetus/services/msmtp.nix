{
  programs.msmtp = {
    enable = true;
    setSendmail = true;

    defaults = {
      auth = true;
      tls = true;
      host = "smtp.migadu.com";
      port = 465;
    };
  };
}
