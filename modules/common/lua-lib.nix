{ config, lib, pkgs, ... }:
{
  options.satellite.lib.lua = {
    writeFile = lib.mkOption {
      type = with lib.types; functionTo (functionTo (functionTo path));
      description = "Format and write a lua file to disk";
    };
  };

  options.satellite.lua.styluaConfig = lib.mkOption {
    type = lib.types.path;
    description = "Config to use for formatting lua modules";
  };

  config.satellite.lib.lua = {
    writeFile = path: name: text:
      let
        destination = "${path}/${name}.lua";
        unformatted = pkgs.writeText "raw-lua-${name}" ''
          -- ❄️ I was generated using nix ^~^
          ${text}
        '';
      in
      pkgs.runCommand "formatted-lua-${name}" { } ''
        mkdir -p $out/${path}
        cp --no-preserve=mode ${unformatted} $out/${destination}
        ${lib.getExe pkgs.stylua} --config-path ${config.satellite.lua.styluaConfig} $out/${destination}
      '';
  };
}
