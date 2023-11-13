{ pkgs, config, lib, ... }:
let storePath = "${config.home.homeDirectory}/.password-store";
in
{
  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = storePath;
  };

  services.pass-secret-service = {
    inherit storePath;
    enable = true;
  };

  # Enable runner integration
  home.packages = lib.lists.optional config.programs.wofi.enable pkgs.wofi-pass;

  # Enable the firefox extension
  home.file.".mozilla/native-messaging-hosts/passff.json".source =
    lib.mkIf config.programs.firefox.enable
      "${pkgs.passff-host}/lib/mozilla/native-messaging-hosts/passff.json";

  satellite.persistence.at.data.apps.pass.directories = [ storePath ];
}
