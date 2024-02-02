{ config, pkgs, ... }:
let workflowDir = "${config.home.homeDirectory}/productivity/smos";
in
{
  # {{{ Smos config 
  programs.smos = {
    inherit workflowDir;

    enable = true;
    notify.enable = true;

    github = {
      enable = true;
      oauth-token-file = config.sops.secrets.smos_github_token.path;
    };
  };
  # }}}
  # {{{ Storage & secrets 
  satellite.persistence.at.data.apps.smos.directories = [
    config.programs.smos.workflowDir
  ];

  sops.secrets.smos_github_token = {
    sopsFile = ../secrets.yaml;
    path = "${config.xdg.dataHome}/smos/.github_token";
  };
  # }}}
  # {{{ Add desktop entry
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
  # }}}
}
