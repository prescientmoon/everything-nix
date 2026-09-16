{ config, ... }:
let
  serverName = config.satellite.dns.domain;
in
{
  satellite.nginx.at.social = {
    port = config.satellite.ports.gotosocial;
    scope = "public";
  };

  services.gotosocial = {
    enable = true;

    environmentFile = config.sops.templates."gotosocial.env".path;
    settings = {
      port = config.satellite.ports.gotosocial;
      host = config.satellite.nginx.at.social.host;
      account-domain = serverName;
      landing-page-user = "prescientmoon";

      instance-expose-custom-emojis = true;
      accounts-allow-custom-css = true;
      accounts-max-profile-fields = 12;

      cache.memory-target = "50MiB";
      metrics-enabled = true;

      smtp-host = "smtp.migadu.com";
      smtp-port = 465;
      smtp-username = "gotosocial@orbit.moonythm.dev";
      smtp-from = "gotosocial@orbit.moonythm.dev";
      smtp-disclose-recipients = true;
    };
  };

  # Secrets
  sops = {
    secrets.gotosocial_email_pass = {
      sopsFile = ../secrets.yaml;
      owner = "gotosocial";
      group = "gotosocial";
    };

    templates."gotosocial.env".content = ''
      GTS_SMTP_PASSWORD=${config.sops.placeholder.gotosocial_email_pass}
    '';
  };

  # Redirects for the split domain setup
  services.nginx.virtualHosts.${serverName}.extraConfig =
    let
      url = config.satellite.nginx.at.social.url;
    in
    ''
      location /.well-known/webfinger {
        rewrite ^.*$ ${url}/.well-known/webfinger permanent;
      }

      location /.well-known/host-meta {
        rewrite ^.*$ ${url}/.well-known/host-meta permanent;
      }

      location /.well-known/nodeinfo {
        rewrite ^.*$ ${url}/.well-known/nodeinfo permanent;
      }
    '';

  # Persistence
  satellite.persistence.at.state.on."/var/lib".directories = [
    {
      base = "gotosocial";
      user = "gotosocial";
      group = "gotosocial";
    }
  ];
}
