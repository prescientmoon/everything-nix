{ config, ... }: {
  sops.secrets.porkbun_secrets.sopsFile = ./secrets.yaml;
  security.acme.acceptTerms = true;
  security.acme.defaults = {
    email = "acme@moonythm.dev";
    dnsProvider = "porkbun";
    environmentFile = config.sops.secrets.porkbun_secrets.path;
  };

  environment.persistence."/persist/state".directories = [
    "/var/lib/acme"
  ];
}
