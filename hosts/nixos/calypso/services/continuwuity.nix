{
  config,
  upkgs,
  lib,
  ...
}:
let
  port = config.satellite.ports.continuwuity;
  cfg = config.services.matrix-continuwuity;
  ngx = config.satellite.nginx.at.continowoity;
  serverName = "owo.${config.satellite.dns.domain}";
in
{
  sops.secrets.continuwuity_token = {
    sopsFile = ../secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
  };

  services.matrix-continuwuity = {
    enable = true;
    package = upkgs.matrix-continuwuity.overrideAttrs (og: {
      cargoBuildFlags = [
        "--no-default-features"
        "--features=bindgen-runtime,standard"
      ];
    });
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

  satellite.nginx.at.continowoity = {
    inherit port;
    subdomain = "owo";
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
