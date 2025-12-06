{
  lib,
  config,
  upkgs,
  ...
}:
{
  programs.anyrun = {
    enable = true;
    package = upkgs.anyrun;

    config = {
      # {{{ Plugins
      plugins = lib.lists.forEach [
        "applications"
        "dictionary"
        "rink"
        "stdin"
      ] (name: "${config.programs.anyrun.package}/lib/lib${name}.so");
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

    extraCss = # css
      ''
        /* {{{ Global overrides */
        window,
        text,
        .main,
        .plugin,
        .match {
          background: transparent;
        }

        * {
          font-size: 2rem;
          outline: none;
        }
        /* }}} */
        /* {{{ Transparent & raised surfaces */
        text,
        .main,
        .match:selected {
          box-shadow: 0.5px 0.5px 1.5px 1.5px rgba(0, 0, 0, 0.5);
          border-radius: ${toString config.satellite.theming.rounding.radius}px;
        }

        text,
        .main {
          margin: 1rem;
          background: rgba(${config.satellite.theming.colors.rgba "base00"});
          min-height: 1rem;
        }
        /* }}} */
        /* {{{ Input */
        text {
          font-size: 2rem;
          padding: 1rem;
          border: none;
        }
        /* }}} */
        /* {{{ Matches */
        row.match {
          margin: 0.7rem;
          margin-bottom: 0.3rem;
          color: ${config.lib.stylix.colors.withHashtag.base05};
          padding: 0.5rem;
          transition: none;
        }

        row.match:last-child {
          margin-bottom: 0.7rem;
        }

        .match:selected {
          padding: 0.5rem;
          color: ${config.lib.stylix.colors.withHashtag.base05};
          background: rgba(${config.satellite.theming.colors.rgb "base03"}, 0.2);
        }

        .match.description {
          font-size: 0;
        }
        /* }}} */
      '';
  };
}
