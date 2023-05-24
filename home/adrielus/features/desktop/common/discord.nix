{ config, ... }: {
  programs.discord = {
    enable = true;
    enableOpenASAR = false;
    disableUpdateCheck = true;
    enableDevtools = true;
  };

  satellite.persistence.at.state.apps.Discord.directories = [
    "${config.xdg.configHome}/discord" # Why tf does discord store it's state here 💀
  ];
}
