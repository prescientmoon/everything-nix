{
  config,
  upkgs,
  lib,
  ...
}:
{
  sops.secrets.tuwunel_token = {
    sopsFile = ../../secrets.yaml;
    owner = config.services.matrix-tuwunel.user;
    group = config.services.matrix-tuwunel.group;
  };

  services.matrix-tuwunel = {
    enable = true;
    package = upkgs.matrix-tuwunel;
    settings.global = {
      port = [ config.satellite.ports.tuwunel ];
      allow_registration = false;
      server_name = "uwu.${config.satellite.dns.domain}";
      registration_token_file = config.sops.secrets.tuwunel_token.path;
    };
  };

  satellite.cloudflared.at.tuwunel = {
    port = config.satellite.ports.tuwunel;
    subdomain = "uwu";
  };

  # HACK: https://github.com/nix-community/impermanence/issues/254
  systemd.services.tuwunel.serviceConfig.DynamicUser = lib.mkForce false;
  environment.persistence."/persist/state".directories = [
    {
      directory = "/var/lib/${config.services.matrix-tuwunel.stateDirectory}";
      user = config.services.matrix-tuwunel.user;
      group = config.services.matrix-tuwunel.group;
    }
  ];
}
