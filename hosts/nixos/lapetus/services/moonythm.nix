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
    error_page 404 /404/index.html;
    proxy_intercept_errors on;

    # Cache fonts for one year
    location /fonts/ {
      add_header Cache-Control "public, max-age=31536000, immutable";
      log_not_found off;
      access_log off;
    }

    # Cache images for one year
    location ~* \.(png|jpg|jpeg|gif|webp|avif|svg)$ {
      add_header Cache-Control "public, max-age=31536000, immutable";
      log_not_found off;
      access_log off;
    }

    # Support not writing out the .html or /index.html suffixes
    location / {
      index index.html;
      try_files $uri $uri.html $uri/ =404;
    }

    # Do not allow querying the 404 file directly
    location = /404/index.html {
      internal;
    }
  '';
}
