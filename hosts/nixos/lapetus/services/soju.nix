{
  services.soju = {
    enable = true;
    extraConfig = ''
      db sqlite3 /persist/state/soju/storage.db
      message-store db
    '';
  };
}
