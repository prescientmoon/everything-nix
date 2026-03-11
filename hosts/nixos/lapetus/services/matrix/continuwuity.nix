{
  config,
  upkgs,
  lib,
  ...
}:
let
  cfg = config.services.matrix-continuwuity;
  cfd = config.satellite.cloudflared.at.continuwuity;
  serverName = config.satellite.dns.domain;
in
{
  sops.secrets.continuwuity_token = {
    sopsFile = ../../secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
  };

  services.matrix-continuwuity = {
    enable = true;
    package = upkgs.matrix-continuwuity;
    settings.global = {
      # This is safe because registrations require having my private
      # registration token!
      allow_registration = true;
      port = [ config.satellite.ports.continuwuity ];
      server_name = serverName;
      registration_token_file = config.sops.secrets.continuwuity_token.path;
      well_known = {
        client = cfd.url;
        server = "${cfd.host}:443";
        support_role = "m.role.admin";
        support_mxid = "@prescientmoon:${serverName}";
        support_email = "hi@moonythm.dev";
      };
    };
  };

  satellite.cloudflared.at.continuwuity = {
    port = config.satellite.ports.continuwuity;
    subdomain = "uwu";
  };

  # Redirects for the split domain setup
  services.nginx.virtualHosts.${serverName}.locations = {
    "/.well-known/matrix/".proxyPass =
      # Redirecting to uwu.moonythm.dev causes errors
      "${cfd.target}/.well-known/matrix/";
  };

  # HACK: https://github.com/nix-community/impermanence/issues/254
  systemd.services.continuwuity.serviceConfig.DynamicUser = lib.mkForce false;
  environment.persistence."/persist/state".directories = [
    {
      directory = cfg.settings.global.database_path;
      user = cfg.user;
      group = cfg.group;
    }
  ];
}
