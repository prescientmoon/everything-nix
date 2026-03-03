# TODO: turn this into a wrapper
# 'inlyne' is a markdown reader
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.inlyne ];

  # Create a hidden desktop entry in order for this to become the default way
  # to open markdown files.
  #
  # See https://specifications.freedesktop.org/desktop-entry-spec/latest/recognized-keys.html
  xdg.desktopEntries.inlyne = {
    noDisplay = true;

    name = "Inlyne";
    type = "Application";

    exec = "${lib.getExe pkgs.inlyne} %U";
    mimeType = [ "text/markdown" ];
  };
}
