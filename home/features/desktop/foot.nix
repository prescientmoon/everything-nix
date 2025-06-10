{ lib, ... }:
{
  stylix.targets.foot.enable = true;

  programs.foot = {
    enable = true;

    settings.key-bindings.regex-copy = "[quick] Control+Shift+p";
    settings."regex:quick" = {
      regex =
        let
          withParens = s: "(${s})";

          # Original regexes taken (& converted to extended posix regexes) from
          # https://github.com/wezterm/wezterm/blob/5106c8c1f799457719ca04f5bd73e7eddaf1de9c/wezterm-gui/src/overlay/quickselect.rs#L26
          regexes = lib.lists.map withParens [
            "([A-Za-z0-9_.@~-]+)?(/[A-Za-z0-9_.@~-]+)+" # paths
            "#[0-9a-fA-F]{6}" # color
            "[0-9]{4,}" # numbers
            "[0-9a-f]{7,40}" # SHA
            "(sha256-)?[A-Za-z0-9+/]{43}=" # Base 64 encoded SHA256 (nix hashes)
            "0x[0-9a-fA-F]+" # hex address
            "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}" # IPv4
            "[A-Fa-f0-9:]+:+[A-Fa-f0-9:]+[%A-Za-z0-9_]+" # IPv6
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" # UUID
          ];
        in
        withParens (lib.concatStringsSep "|" regexes);
    };
  };
}
