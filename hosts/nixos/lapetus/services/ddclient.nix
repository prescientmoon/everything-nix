# DDClient is a dynamic dns service
{ config, pkgs, ... }:
{
  imports = [ ../../common/optional/services/acme.nix ];

  services.ddclient = {
    enable = true;
    interval = "1m";
    configFile = config.sops.templates."ddclient.conf".path;

    # REASON: latest release doesn't support explicit root-domain annotations for porkbun
    package = pkgs.ddclient.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "ddclient";
        repo = "ddclient";
        rev = "9885d55a3741363ad52d3463cb846d5782efb073";
        sha256 = "0zyi8h13y18vrlxavx1vva4v0ya5v08bxdxlr3is49in3maz2n37";
      };
    });
  };

  sops.templates."ddclient.conf".content = ''
    # General settings
    cache=/var/lib/ddclient/ddclient.cache # See the nixos module for details
    foreground=YES

    # Routers
    use=web, web=checkip.dyndns.com/, web-skip='Current IP Address: '

    # Protocols
    protocol=porkbun
    apikey=${config.sops.placeholder.porkbun_api_key}
    secretapikey=${config.sops.placeholder.porkbun_secret_api_key}
    root-domain=moonythm.dev # The root domain detection doesn't work properly
    real.lapetus.moonythm.dev
  '';
}

