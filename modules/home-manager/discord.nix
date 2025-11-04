{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.discord;
  jsonFormat = pkgs.formats.json { };
in
{
  meta.maintainers = with lib.maintainers; [
    prescientmoon
  ];

  options.programs.discord = {
    enable = lib.mkEnableOption "Discord, the chat platform";
    package = lib.mkPackageOption pkgs "discord" { };
    enableDevtools = lib.mkEnableOption "Chrome's webtools inside Discord";
    enableUpdateChecks = lib.mkEnableOption "Discord's automatic update checks";
  };

  config = lib.mkIf cfg.enable (
    let
      config."discord/settings.json".source = jsonFormat.generate "discord-settings" {
        SKIP_HOST_UPDATE = !cfg.enableUpdateChecks;
        DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = cfg.enableDevtools;
      };
    in
    lib.mkMerge [
      {
        home.packages = [ cfg.package ];
      }
      (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) { xdg.configFile = config; })
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        home.file = lib.mapAttrs' (n: v: lib.nameValuePair "Library/Application Support/${n}" v) config;
      })
    ]
  );
}
