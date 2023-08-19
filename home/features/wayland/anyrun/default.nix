{ inputs, pkgs, ... }: {
  programs.anyrun = {
    enable = true;
    config = {
      # {{{ Plugins
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        rink
        stdin
        # symbols # Looks ugly atm
        # websearch
        # inputs.anyrun-nixos-options.packages.${pkgs.system}.default # Idk how to set this up :(
      ];
      # }}}
      # {{{ Geometry 
      x.fraction = 0.5;
      y.fraction = 0.25;
      width.fraction = 0.5;
      # }}}

      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 7;
    };

    extraCss = null;
  };

  # # See [the readme](https://github.com/n3oney/anyrun-nixos-options) for anyrun-nixos-options.
  # programs.anyrun.extraConfigFiles."nixos-options.ron".text = ''
  #   Config(
  #     options_path: "${config.system.build.manual.optionsJSON}/share/doc/nixos/options.json"
  #   )
  # '';

  # home.packages =
  #   let anyrunScript = name: plugin: pkgs.writeShellScriptBin "anyrun-${plugin}";
  #   in
  #   [ (anyrunScript "launch" "applications") ];
}
