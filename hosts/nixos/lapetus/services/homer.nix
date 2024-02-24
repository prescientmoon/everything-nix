{ pkgs, config, ... }:
let
  colors = with config.lib.stylix.scheme.withHashtag; {
    highlight-primary = base0A;
    highlight-secondary = base09;
    highlight-hover = base08;
    text-header = base00;
    text-title = base05;
    text-subtitle = base05;
    text = base05;
    link = base08;
    background = base00;
    card-background = base01;
  };

  fa = name: "fas fa-${name}";
  iconPath = ../../../../common/icons;
  icon = file: "assets/${iconPath}/${file}";
in
{
  services.nginx.virtualHosts."lab.moonythm.dev" = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    root = pkgs.homer.withAssets {
      extraAssets = [ iconPath ];
      config = {
        title = "✨ The celestial citadel ✨";

        header = false;
        footer = false;
        connectivityCheck = true;

        colors.light = colors;
        colors.dark = colors;

        services = [
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
                name = "Syncthing";
                subtitle = "File synchronization";
                logo = icon "syncthing.png";
                url = "https://syncthing.lapetus.moonythm.dev";
              }
              {
                name = "Whoogle";
                subtitle = "Search engine";
                logo = icon "whoogle.webp";
                url = "https://search.moonythm.dev";
              }
            ];
          }
          {
            name = "Productivity";
            icon = fa "rocket";
            items = [
              {
                name = "Intray";
                subtitle = "GTD capture tool";
                icon = fa "cubes-stacked";
                url = "https://intray.moonythm.dev";
              }
              {
                name = "Smos";
                subtitle = "A comprehensive self-management system.";
                icon = fa "list";
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
        ];
      };
    };
  };
}
