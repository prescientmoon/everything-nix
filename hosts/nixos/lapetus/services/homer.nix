{ pkgs, config, ... }:
let
  # {{{ Colors
  colors = with config.lib.stylix.scheme.withHashtag; {
    highlight-primary = base09;
    highlight-secondary = base01;
    highlight-hover = base00;
    text-header = base05;
    text-title = base05;
    text-subtitle = base05;
    text = base05;
    link = base08;
    background = base00;
    card-background = base01;
  };
  # }}}

  fa = name: "fas fa-${name}";
  iconPath = ../../../../common/icons;
  icon = file: "assets/${iconPath}/${file}";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  services.nginx.virtualHosts."lab.moonythm.dev" =
    config.satellite.static (pkgs.homer.withAssets {
      extraAssets = [ iconPath ];
      config = {
        title = "✨ The celestial citadel ✨";

        header = false;
        footer = false;
        connectivityCheck = true;

        colors.light = colors;
        colors.dark = colors;

        services = [
          # {{{ Infrastructure
          {
            name = "Infrastructure";
            icon = fa "code";
            items = [
              {
                name = "Prometheus";
                type = "Prometheus";
                subtitle = "Monitoring system";
                logo = icon "prometheus.png";
                url = "https://prometheus.moonythm.dev";
              }
              {
                name = "Grafana";
                subtitle = "Pretty dashboards :3";
                logo = icon "grafana.png";
                url = "https://grafana.moonythm.dev";
              }
              {
                name = "Syncthing";
                subtitle = "File synchronization";
                logo = icon "syncthing.png";
                url = "https://lapetus.syncthing.moonythm.dev";
              }
            ];
          }
          # }}}
          # {{{ Pillars
          {
            name = "Pillars";
            icon = fa "toolbox";
            items = [
              {
                name = "Vaultwarden";
                subtitle = "Password manager";
                logo = icon "bitwarden.png";
                url = "https://warden.moonythm.dev";
              }
              {
                name = "Whoogle";
                subtitle = "Search engine";
                logo = icon "whoogle.webp";
                url = "https://search.moonythm.dev";
              }
              {
                name = "Commafeed";
                subtitle = "RSS reader";
                logo = icon "commafeed.png";
                url = "https://rss.moonythm.dev";
              }
            ];
          }
          # }}}
          # {{{ Productivity
          {
            name = "Productivity";
            icon = fa "rocket";
            items = [
              {
                name = "Intray";
                subtitle = "GTD capture tool";
                icon = fa "inbox";
                url = "https://intray.moonythm.dev";
              }
              {
                name = "Smos";
                subtitle = "A comprehensive self-management system.";
                icon = fa "cubes-stacked";
                url = "https://smos.moonythm.dev";
              }
              {
                name = "Actual";
                subtitle = "Budgeting tool";
                logo = icon "actual.png";
                url = "https://actual.moonythm.dev";
              }
            ];
          }
          # }}}
          # {{{ Entertainment
          {
            name = "Entertainment";
            icon = fa "gamepad";
            items = [
              {
                name = "Invidious";
                subtitle = "Youtube client";
                logo = icon "invidious.png";
                url = "https://yt.moonythm.dev";
              }
              {
                name = "Diptime";
                subtitle = "Diplomacy timer";
                icon = fa "globe";
                url = "https://diptime.moonythm.dev";
              }
            ];
          }
          # }}}
        ];
      };
    });
}
