{
  config,
  upkgs,
  lib,
  ...
}:
let
  port = config.satellite.ports.continuwuity;
  cfg = config.services.matrix-continuwuity;
  ngx = config.satellite.nginx.at.continuwuity;
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
      port = [ port ];
      server_name = serverName;
      registration_token_file = config.sops.secrets.continuwuity_token.path;
      well_known = {
        client = ngx.url;
        server = "${ngx.host}:443";
        support_role = "m.role.admin";
        support_mxid = "@prescientmoon:${serverName}";
        support_email = "hi@moonythm.dev";
      };
    };
  };

  satellite.nginx.at.continuwuity = {
    inherit port;
    subdomain = "uwu";
    scope = "public";
    vhost.extraConfig = ''
      access_log /var/log/nginx/access.log with_the_host;
    '';
  };

  # Redirects for the split domain setup
  satellite.nginx.at."".vhost = {
    locations."/.well-known/matrix/" = {
      proxyPass =
        # Redirecting to uwu.moonythm.dev causes errors
        "http://localhost:${toString port}/.well-known/matrix/";
    };
  };

  # This was the original issue I bumped into:
  # https://github.com/nix-community/impermanence/issues/254
  #
  # I now no longer use the impermanence module (I use my own rewrite). My
  # rewrite would allow me to work around this issue, but I don't want to break
  # a past setup that worked :) I will no longer need to do this in the future,
  # though!
  systemd.services.continuwuity.serviceConfig.DynamicUser = lib.mkForce false;
  satellite.persistence.at.state.on."/var/lib".directories = [
    {
      inherit (cfg) user group;
      base = "continuwuity";
    }
  ];
}
