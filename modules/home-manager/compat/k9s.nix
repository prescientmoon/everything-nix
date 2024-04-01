{ config, lib, pkgs, ... }:

with lib;

let
  yamlFormat = pkgs.formats.yaml { };

in {
  options.programs.k9s = {
    skins = mkOption {
      type = types.attrsOf yamlFormat.type;
      default = { };
      description = ''
        Skin files written to {file}`$XDG_CONFIG_HOME/k9s/skins/`. See
        <https://k9scli.io/topics/skins/> for supported values.
      '';
      example = literalExpression ''
        my_blue_skin = {
          k9s = {
            body = {
              fgColor = "dodgerblue";
            };
          };
        };
      '';
    };
  };
}
