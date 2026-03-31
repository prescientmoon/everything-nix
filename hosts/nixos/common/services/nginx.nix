{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.satellite.nginx;

  listenAddresses = {
    overlay = lib.filter (v: v != null) [
      cfg.overlayAddress.ipv4
      "[${cfg.overlayAddress.ipv6}]"
    ];

    friends = lib.filter [
      cfg.friendsOverlayAddress.ipv4
      "[${cfg.friendsOverlayAddress.ipv6}]"
    ];

    public = [
      "0.0.0.0"
      "[::]"
    ];
  };

  mkNginxConfig =
    subcfg:
    let
      extra =
        if subcfg.port != null then
          {
            locations."/" = {
              proxyPass = "http://localhost:${toString subcfg.port}";
              proxyWebsockets = lib.mkDefault true;
            };
          }
        else if subcfg.files != null then
          {
            root = subcfg.files;
            locations."/" = {
              tryFiles = "$uri $uri/ =404";
              index = "index.html";
            };
          }
        else
          { };
    in
    lib.mkMerge [
      {
        enableACME = true;
        acmeRoot = null;
        forceSSL = true;
        listenAddresses = listenAddresses.${subcfg.scope};
      }
      extra
    ];

  # We automatically generate CNAME records for the configured services!
  mkDnsRecord =
    { subdomain, scope, ... }:
    {
      type = if subdomain == "" then "ALIAS" else "CNAME";
      zone = cfg.domain;
      at = subdomain;
      to = "${config.networking.hostName}.${scope}";
    };

  mkAddressOption =
    version: exposedOver:
    lib.mkOption {
      description = ''
        The IPv${toString version} address to use for services exposed
        over ${exposedOver}.
      '';
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

in
{
  options.satellite.nginx = {
    enable = lib.mkEnableOption "satellite's nginx integration" // {
      default = true;
    };

    domain = lib.mkOption {
      description = "Root domain to use as a default for configurations.";
      type = lib.types.str;
      default = config.satellite.dns.domain;
    };

    overlayAddress.ipv4 = mkAddressOption 4 "my overlay network";
    overlayAddress.ipv6 = mkAddressOption 6 "my overlay network";
    friendsOverlayAddress.ipv4 = mkAddressOption 4 "my friends' overlay network";
    friendsOverlayAddress.ipv6 = mkAddressOption 6 "my friends' overlay network";

    at = lib.mkOption {
      description = "Per-subdomain nginx configuration";
      default = { };

      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options.scope = lib.mkOption {
              default = "overlay";
              type = lib.types.enum [
                "overlay"
                "friends"
                "public"
              ];
              description = ''
                Where should the service be accessible from? The options are:
                - `overlay`: open to my personal overlay network (the default)
                - `friends`: open to my friends' overlay network
                - `public`:  accessible by anyone
              '';
            };

            options.location = lib.mkOption {
              default = "";
              type = lib.types.str;
              description = "Subpath to proxy to";
            };

            options.subdomain = lib.mkOption {
              description = ''
                Subdomain to use for host generation.
                Only required if `host` is not set manually.
              '';
              type = lib.types.str;
              default = name;
            };

            config.host =
              if config.subdomain == "" then # .
                cfg.domain
              else
                "${config.subdomain}.${cfg.domain}";

            options.host = lib.mkOption {
              description = "Host to route requests from";
              type = lib.types.str;
            };

            config.url = "https://${config.host}";
            options.url = lib.mkOption {
              description = "External https url used to access this host";
              type = lib.types.str;
            };

            options.port = lib.mkOption {
              description = "Port to proxy requests to";
              type = lib.types.nullOr lib.types.port;
              default = null;
            };

            options.files = lib.mkOption {
              description = "Path to serve files from";
              type = lib.types.nullOr lib.types.path;
              default = null;
            };

            config.vhost = mkNginxConfig config;
            options.vhost = lib.mkOption {
              description = "Arbitrary Nginx configuration options";
              type =
                # I find the fact this is possible to be pretty cool!
                options.services.nginx.virtualHosts.type.nestedTypes.elemType;
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.pipe cfg.at [
      (lib.mapAttrsToList (
        _: config: [
          {
            assertion = (config.port == null) || (config.files == null);
            message = ''
              The options
                'satellite.nginx.at.${config.subdomain}.port'
              and 
                'satellite.nginx.at.${config.subdomain}.files'
              cannot be specified at the same time.
            '';
          }
          {
            assertion =
              (config.scope != "overlay")
              || (cfg.overlayAddress.ipv4 != null)
              || (cfg.overlayAddress.ipv6 != null);
            message = ''
              The option
                'satellite.nginx.at.${config.subdomain}.scope'
              is set to
                'overlay'
              even though no addresses for the overlay network are given.
            '';
          }
          {
            assertion =
              (config.scope != "friends")
              || (cfg.friendsOverlayAddress.ipv4 != null)
              || (cfg.friendsOverlayAddress.ipv6 != null);
            message = ''
              The option
                'satellite.nginx.at.${config.subdomain}.scope'
              is set to
                'friends'
              even though no addresses for the friends network are given.
            '';
          }
        ]
      ))
      lib.flatten
    ];

    satellite.acme.enable = true;
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true; # Necessary for the Prometheus exporter
      virtualHosts = lib.attrsets.mapAttrs' (_: scfg: {
        name = scfg.host;
        value = scfg.vhost;
      }) cfg.at;
    };

    satellite.dns.records = [
      (lib.mkIf (cfg.overlayAddress.ipv4 != null) {
        at = "${config.networking.hostName}.overlay";
        type = "A";
        value = cfg.overlayAddress.ipv4;
      })
      (lib.mkIf (cfg.overlayAddress.ipv6 != null) {
        at = "${config.networking.hostName}.overlay";
        type = "AAAA";
        value = cfg.overlayAddress.ipv6;
      })
      (lib.mkIf (cfg.friendsOverlayAddress.ipv4 != null) {
        at = "${config.networking.hostName}.friends";
        type = "A";
        value = cfg.friendsOverlayAddress.ipv4;
      })
      (lib.mkIf (cfg.friendsOverlayAddress.ipv6 != null) {
        at = "${config.networking.hostName}.friends";
        type = "AAAA";
        value = cfg.friendsOverlayAddress.ipv6;
      })
    ]
    ++ lib.attrsets.mapAttrsToList (_: mkDnsRecord) cfg.at;
  };
}
