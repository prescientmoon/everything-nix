{ config, ... }: {
  programs.smos = {
    enable = true;
    notify.enable = true;
    workflowDir = "${config.home.homeDirectory}/productivity/smos";

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
}
