{
  inputs,
  lib,
  ...
}:
let
  dir = inputs.sillyring.outPath;
  members = (lib.importTOML "${dir}/links.toml").members;
  redirectConfig = lib.concatStringsSep "\n" (
    lib.lists.imap0 (
      ix:
      { nickname, ... }:
      let
        lookup =
          i:
          if i < 0 then
            lookup (i + builtins.length members)
          else if i >= builtins.length members then
            lookup (i - builtins.length members)
          else
            (builtins.elemAt members i).link;
      in
      ''
        location = /${nickname}/prev {
          return 302 ${lookup (ix - 1)};
        }

        location = /${nickname}/next {
          return 302 ${lookup (ix + 1)};
        }
      ''
    ) members
  );
in
{
  satellite.cloudflared.at."silly".port = 80;
  services.nginx.virtualHosts."silly.moonythm.dev".extraConfig = ''
    gzip on;
    charset utf-8;
    override_charset on;

    root ${dir};
    location / {
      index index.html;
    }

    ${redirectConfig}
  '';
}
