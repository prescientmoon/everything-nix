{ config, ... }: {
  sops.secrets.cloudflare_dns_api_token.sopsFile = ../../secrets.yaml;

  sops.templates."acme.env".content = ''
    CF_DNS_API_TOKEN=${config.sops.placeholder.cloudflare_dns_api_token}
  '';

  security.acme.acceptTerms = true;
  security.acme.defaults = {
    email = "acme@moonythm.dev";
    dnsProvider = "cloudflare";
    environmentFile = config.sops.templates."acme.env".path;
  };

  environment.persistence."/persist/state".directories = [
    "/var/lib/acme"
  ];
}
