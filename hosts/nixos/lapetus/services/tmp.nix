# Serve /persist/state/var/lib/tmp at tmp.moonythm.dev. Useful for
# programatically sharing files to IRC and whatnot.
#
# Right now adding files here requires root access to the server. This could
# easly be changed, although I do not have a good reason to do so righ now.
{ config, ... }:
let
  path = "/persist/state/var/lib/tmp";
in
{
  satellite.cloudflared.at.tmp.port = 80;
  services.nginx.virtualHosts."tmp.${config.satellite.dns.domain}" = {
    # Redirect the root page to my website
    locations."= /".return = "301 https://${config.satellite.dns.domain}";
    locations."/".root = path;
  };

  # Clean files that have been there for more than a month
  systemd.tmpfiles.rules = [ "d ${path} - - - 30d" ];
}
