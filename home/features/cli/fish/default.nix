# TODO: move this to nixos (it would be nice to have it as root and whatnot as
# well)
{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${builtins.readFile ./config.fish}

      # Modify nix-shell to use `fish` as its default shell
      ${lib.getExe pkgs.nix-your-shell} fish | source
    '';

    # {{{ Plugins
    plugins =
      let
        plugins = with pkgs.fishPlugins; [
          z # Jump to directories by typing "z <directory-name>"
        ];
      in
      # For some reason home-manager expects a slightly different format 🤔
      lib.forEach plugins (plugin: {
        inherit (plugin) src;
        name = plugin.pname;
      });
    # }}}
  };

  satellite.persistence.at.state.at.fish.directories = [
    "${config.xdg.dataHome}/fish"
    "${config.xdg.dataHome}/z" # The z fish plugin requires this
  ];
}
