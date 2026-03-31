{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = # .
    "${config.networking.hostName}.public.${config.satellite.dns.domain}";

  mkConfig = ip_version: {
    inherit domain ip_version;
    provider = "cloudflare";
    zone_identifier = "67af42f2e361c4ed74588a831a2491b5";
    token = config.sops.placeholder.cloudflare_dns_api_token;
    ttl = 300;
  };
in
{
  sops.secrets.cloudflare_dns_api_token.sopsFile = ../../common/secrets.yaml;
  sops.templates."ddns-updater.json".content = builtins.toJSON {
    settings = [
      (mkConfig "ipv4")
      (mkConfig "ipv6")
    ];
  };

  satellite.nginx.at.ddns.port = config.satellite.ports.ddns-updater;
  systemd.services.ddns-updater = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    unitConfig.Description = "DDNS-updater service";
    environment = {
      DATADIR = "%S/ddns-updater";
      LISTENING_ADDRESS = ":${toString config.satellite.ports.ddns-updater}";
    };

    serviceConfig = {
      TimeoutSec = "5min";
      RestartSec = 30;
      DynamicUser = true;
      StateDirectory = "ddns-updater";
      Restart = "on-failure";
      LoadCredential = # .
        "config:${config.sops.templates."ddns-updater.json".path}";
    };

    script = ''
      export CONFIG_FILEPATH=$CREDENTIALS_DIRECTORY/config
      ${lib.getExe pkgs.ddns-updater};
    '';
  };
}
