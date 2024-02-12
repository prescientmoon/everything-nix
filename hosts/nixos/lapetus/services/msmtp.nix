{
  programs.msmtp = {
    enable = true;
    setSendmail = true;

    defaults = {
      auth = true;
      tls = true;
      tls_starttls = false;
      host = "smtp.migadu.com";
      port = 465;
    };
  };
}
