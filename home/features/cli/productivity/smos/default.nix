{ config, pkgs, ... }:
let workflowDir = "${config.home.homeDirectory}/productivity/smos";
in
{
  programs.smos = {
    inherit workflowDir;

    enable = true;
    notify.enable = true;

    github = {
      enable = true;
      oauth-token-file = config.homeage.file.smos.path;
    };
  };

  satellite.persistence.at.data.apps.smos.directories = [
    config.programs.smos.workflowDir
  ];

  homeage.file.smos = {
    source = ./smos_github_oauth.age;
    path = "${config.xdg.dataHome}/smos/.github_token";
  };

  home.packages =
    # Start smos with a custom class so our WM can move it to the correct workspace
    let smosgui = pkgs.writeShellScriptBin "smosgui" ''
      wezterm start --class "org.wezfurlong.wezterm.smos" --cwd ${workflowDir} smos
    '';
    in
    [ smosgui ];

  xdg.desktopEntries.smosgui = {
    name = "Smos GUI";
    type = "Application";
    exec = "smosgui";
    terminal = false;
  };
}
