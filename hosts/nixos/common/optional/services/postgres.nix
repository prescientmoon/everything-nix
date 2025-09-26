{
  services.postgresql.enable = true;
  environment.persistence."/persist/state".directories = [
    {
      directory = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
    }
  ];
}
