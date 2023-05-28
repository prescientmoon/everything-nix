{ pkgs, inputs, ... }:
let
  # {{{ Global extensions
  extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    buster-captcha-solver
    bypass-paywalls-clean
    clearurls # removes ugly args from urls
    don-t-fuck-with-paste # disallows certain websites from disabling pasting
    gesturefy # mouse gestures
    i-dont-care-about-cookies
    localcdn # caches libraries locally
    privacy-badger # blocks some trackers
    privacy-pass # captcha stuff
    skip-redirect # attempts to skip to the final reddirect for certain urls
    terms-of-service-didnt-read
    translate-web-pages
    ublock-origin
    unpaywall
    user-agent-string-switcher
  ];
  # }}}
in
{
  programs.firefox = {
    enable = true;

    profiles.adrielus = {
      # {{{ High level user settings
      # Unique user id
      id = 0;

      # Make this the default user
      isDefault = true;

      # Forcefully replace the search configuration
      search.force = true;

      # Set default search engine
      search.default = "Google";

      # Set styles applied to every website
      userContent = builtins.readFile ./userContent.css;
      # }}}
      # {{{ Extensions
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; extensions ++ [
        firenvim # summon a nvim instance inside the browser
        lovely-forks # displays forks on github
        octolinker # github import to link thingy
        octotree # github file tree
        refined-github # a bunch of github modifications
        return-youtube-dislikes
        steam-database # adds info from steamdb on storepages
        sponsorblock # skip youtube sponsors
        vimium-c # vim keybinds
        youtube-shorts-block
      ];
      # }}}
      # {{{ Search engines
      search.engines =
        let
          # {{{ Search engine creation helpers
          mkBasicSearchEngine = { aliases, url, param }: {
            urls = [{
              template = url;
              params = [
                { name = param; value = "{searchTerms}"; }
              ];
            }];

            definedAliases = aliases;
          };

          mkNixPackagesEngine = { aliases, type }:
            let basicEngine = mkBasicSearchEngine
              {
                aliases = aliases;
                url = "https://search.nixos.org/${type}";
                param = "query";
              };
            in
            basicEngine // {
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
          # }}}
        in
        # {{{ Engine declarations
        {
          "Nix Packages" = mkNixPackagesEngine {
            aliases = [ "@np" "@nix-packages" ];
            type = "packages";
          };

          "Nix options" = mkNixPackagesEngine {
            aliases = [ "@no" "@nix-options" ];
            type = "options";
          };

          # Purescript packages
          "Pursuit" = mkBasicSearchEngine {
            url = "https://pursuit.purescript.org/search";
            param = "q";
            aliases = [ "@ps" "@pursuit" ];
          };

          "Wikipedia" = mkBasicSearchEngine {
            url = "https://en.wikipedia.org/wiki/Special:Search";
            param = "search";
            aliases = [ "@wk" "@wikipedia" ];
          };

          "Github" = mkBasicSearchEngine {
            url = "https://github.com/search";
            param = "q";
            aliases = [ "@gh" "@github" ];
          };

          "Youtube" = mkBasicSearchEngine {
            url = "https://www.youtube.com/results";
            param = "search_query";
            aliases = [ "@yt" "@youtube" ];
          };

          "Noita wiki" = mkBasicSearchEngine {
            url = "https://noita.wiki.gg/index.php";
            param = "search";
            aliases = [ "@noita" ];
          };

          "Rain world wiki" = mkBasicSearchEngine {
            url = "https://rainworld.miraheze.org/w/index.php";
            param = "search";
            aliases = [ "@rw" "@rain-world" ];
          };

          "Factorio wiki" = mkBasicSearchEngine {
            url = "https://wiki.factorio.com/index.php";
            param = "search";
            aliases = [ "@fw" "@factorio-wiki" ];
          };

          "Factorio mod portal" = mkBasicSearchEngine {
            url = "https://mods.factorio.com/";
            param = "query";
            aliases = [ "@fm" "@factorio-mods" ];
          };

          "Google".metaData.alias = "@g";
        };
      # }}}
      # }}}
      # {{{ Other lower level settings
      settings = {
        # Required for figma to be able to export to svg
        "dom.events.asyncClipboard.clipboardItem" = true;

        # Customize css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Set language to english
        "general.useragent.locale" = "en-GB";

        # Do not restore sessions after what looks like a "crash"
        "browser.sessionstore.resume_from_crash" = false;

        # Tell firefox to make multiple requests at once
        # See [this random page](https://doorsanchar.com/how-to-make-mozilla-firefox-30-times-faster/)
        # "network.http.pipelining" = true;
        # "network.http.proxy.pipelining" = true;
        # "network.http.pipelining.maxrequests" = 30; # Allow 30 requests at once
        # "nglayout.initialpaint.delay" = 0;
      };
      # }}}
    };

    # {{{ Standalone "apps" which actually run inside a browser.
    apps.extensions = extensions;
    apps.app = {
      # {{{ Job stuff
      asana = {
        url = "https://app.asana.com/";
        icon = ./icons/asana.png;
        displayName = "Asana";
        id = 1;
      };

      clockodo = {
        url = "https://my.clockodo.com/en/";
        icon = ./icons/clockodo.png;
        displayName = "Clockodo";
        id = 2;
      };
      # }}}

      gitlab = {
        url = "https://gitlab.com";
        icon = ./icons/gitlab.png;
        displayName = "Gitlab";
        id = 3;
      };

      desmos = {
        url = "https://www.desmos.com/calculator";
        icon = ./icons/desmos.png;
        displayName = "Desmos";
        id = 4;
      };

      monkey-type = {
        url = "https://monkeytype.com/";
        icon = ./icons/monkeytype.png;
        displayName = "Monkeytype";
        id = 5;
      };
    };
    # }}}
  };

  # {{{ Make firefox the default
  # Use firefox as the default browser to open stuff.
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  # Tell apps firefox is the default browser using an env var.
  home.sessionVariables.BROWSER = "firefox";
  # }}}

  # {{{ Persistence
  home.persistence."/persist/home/adrielus".directories = [
    ".cache/mozilla/firefox" # Non important cache
    ".mozilla/firefox" # More important stuff
  ];
  # }}}
}

