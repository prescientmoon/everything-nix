{ config, ... }: {
  programs.smos = {
    enable = true;
    notify.enable = true;
    config = { };
  };

  satellite.persistence.at.data.apps.smos.directories = [
    config.programs.smos.workflowDir
  ];
}
