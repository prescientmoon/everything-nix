{ pkgs, config, lib, ... }:
let storePath = "${config.home.homeDirectory}/.password-store";
in
{
  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = storePath;
    package = pkgs.pass;
  };

  services.pass-secret-service = {
    inherit storePath;
    enable = true;
  };

  home.packages = lib.mkIf config.programs.wofi.enable [
    pkgs.wofi-pass
  ];

  satellite.persistence.at.data.apps.pass.directories = [ storePath ];
}
