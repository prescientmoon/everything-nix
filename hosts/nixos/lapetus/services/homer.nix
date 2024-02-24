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
  icon = file: "./assets/${../../../../common/icons/${file}}";
in
{
  services.nginx.virtualHosts."lab.moonythm.dev" = {
    enableACME = true;
    acmeRoot = null;
    forceSSL = true;
    root = pkgs.homer.withAssets {
      extraAssets = [ ../../../../common/icons ];
      config = {
        title = "✨ The celestial citadel ✨";
        subtitle = "The home for my homelab :3";

        header = true;
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
                url = "warden.moonythm.dev";
                keywords = "pass";
              }
              {
                name = "Syncthing";
                subtitle = "File synchronization";
                logo = icon "syncthing.png";
                url = "syncthing.lapetus.moonythm.dev";
              }
              {
                name = "Whoogle";
                subtitle = "Search engine";
                logo = icon "whoogle.webp";
                url = "search.moonythm.dev";
                keywords = "search google";
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
                url = "intray.moonythm.dev";
              }
              {
                name = "Smos";
                subtitle = "A comprehensive self-management system.";
                icon = fa "list";
                url = "smos.moonythm.dev";
              }
              {
                name = "Actual";
                subtitle = "Budgeting tool";
                logo = icon "actual.png";
                url = "actual.moonythm.dev";
              }
            ];
          }
        ];
      };
    };
  };
}
