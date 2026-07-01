{
  config,
  upkgs,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.ffmpeg
    pkgs.picard # I can use this to manually edit metadata before importing
    (upkgs.python3.pkgs.beets.override {
      pluginOverrides.fetchart.enable = true;
      pluginOverrides.lyrics.enable = true;
      pluginOverrides.lastgenre.enable = true;
      pluginOverrides.embedart.enable = true;
      pluginOverrides.VGMdb = {
        enable = true;
        propagatedBuildInputs = [
          (upkgs.python3Packages.callPackage ./beets-vgmdb.nix { })
        ];
      };
    })
  ];

  xdg.configFile."beets/config.yaml".source =
    config.satellite.dev.path "home/features/cli/beets/config.yaml";

  satellite.persistence.at.state.apps.beets.directories = [
    "${config.xdg.dataHome}/beets"
  ];
}
