{ config, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      promptToReturnFromSubprocess = false;
      disableStartupPopups = true;
    };
  };

  satellite.persistence.at.state.apps.lazygit.directories = [ "${config.xdg.configHome}/lazygit" ];
}
