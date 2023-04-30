{ pkgs, config, ... }: {
  home.packages = [
    pkgs.signal-desktop # Signal client
  ];

  satellite.persistence.at.state.apps.Signal.directories = [
    "${config.xdg.configHome}/Signal" # Why tf does signal store it's state here 💀
  ];
}
