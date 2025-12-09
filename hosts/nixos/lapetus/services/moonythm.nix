{
  inputs,
  upkgs,
  ...
}:
let
  nihil = import inputs.nihil { pkgs = upkgs; };
  dir = "${nihil.moonythm}/web";
in
{
  satellite.cloudflared.at."".port = 80;
  services.nginx.virtualHosts."moonythm.dev".extraConfig = ''
    gzip on;
    charset utf-8;
    override_charset on;

    root ${dir};
    error_page 404 /404;

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
