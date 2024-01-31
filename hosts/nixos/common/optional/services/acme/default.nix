{ config, ... }: {
  sops.secrets.porkbun_secrets.sopsFile = ./secrets.yaml;
  security.acme.acceptTerms = true;
  security.acme.defaults = {
    # TODO: update this email
    email = "rafaeladriel11@gmail.com";
    dnsProvider = "porkbun";
    environmentFile = config.sops.secrets.porkbun_secrets.path;
  };
}
