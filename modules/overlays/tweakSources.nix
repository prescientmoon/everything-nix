self: super:
with self; {
  discord = unstable.discord;
  vscode = unstable.vscode;
  tetrio-desktop = unstable.tetrio-desktop;
}
# let version = "0.0.15";
# in self
# {
# discord = super.discord.overrideAttrs (old: {
#   inherit version;
#   src = builtins.fetchurl {
#     url =
#       "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
#     sha256 = "0pn2qczim79hqk2limgh88fsn93sa8wvana74mpdk5n6x5afkvdd";
#   };
# });
# }
