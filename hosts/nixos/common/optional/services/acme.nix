{ config, ... }: {
  sops.secrets.porkbun_api_key.sopsFile = ../../secrets.yaml;
  sops.secrets.porkbun_secret_api_key.sopsFile = ../../secrets.yaml;

  sops.templates."acme.env".content = ''
    PORKBUN_API_KEY=${config.sops.placeholder.porkbun_api_key}
    PORKBUN_SECRET_API_KEY=${config.sops.placeholder.porkbun_secret_api_key}
  '';

  security.acme.acceptTerms = true;
  security.acme.defaults = {
    email = "acme@moonythm.dev";
    dnsProvider = "porkbun";
    environmentFile = config.sops.templates."acme.env".path;
  };

  environment.persistence."/persist/state".directories = [
    "/var/lib/acme"
  ];
}
