{
  inputs,
  pkgs,
  ...
}:
let
  dir = inputs.moonythm.packages.${pkgs.system}.moonythm;
in
{
  satellite.cloudflared.at."".port = 8080;

  satellite.nginx.at."".files = dir;
  services.nginx.virtualHosts."".extraConfig = ''
    root ${dir};
    error_page 404 /404.html;

    proxy_intercept_errors on;
    location / {
      index index.html;
      try_files $uri $uri.html $uri/ =404;
    }

    location = /404.html {
      internal;
    }
  '';
}
