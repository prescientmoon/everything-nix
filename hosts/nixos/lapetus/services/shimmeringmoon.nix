{
  config,
  inputs,
  pkgs,
  ...
}:
let
  user = config.services.glass-server.user;
  pkg = inputs.shimmeringmoon.packages.${pkgs.system}.default;
  dataDir = "/persist/state/var/lib/shimmeringmoon";
in
{
  systemd.services.shimmeringmoon = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Arcaea score analyzer discord bot";
    environment.SHIMMERING_DATA_DIR = dataDir;
    serviceConfig = {
      User = user;
      Group = user;
      ExecStart = "${pkg}/bin/shimmering-discord-bot";

      Restart = "on-failure";
      LogsDirectory = "shimmeringmoon";
      EnvironmentFile = config.sops.templates.shimmering_env_file.path;
    };
  };

  systemd.tmpfiles.rules = [ "d ${dataDir} 0755 ${user} ${user}" ];

  # {{{ Secrets
  sops.secrets.shimmering_discord_token = {
    owner = user;
    group = user;
    sopsFile = ../secrets.yaml;
  };

  sops.templates.shimmering_env_file = {
    owner = user;
    group = user;
    content = ''
      SHIMMERING_DISCORD_TOKEN        = ${config.sops.placeholder.shimmering_discord_token};
      SHIMMERING_PRIVATE_SERVER_TOKEN = ${config.sops.placeholder.glass_server_admin_token};
      SHIMMERING_PRIVATE_SERVER_URL   = ${config.satellite.cloudflared.at.arcaea.url};
    '';
  };
  # }}}
}
