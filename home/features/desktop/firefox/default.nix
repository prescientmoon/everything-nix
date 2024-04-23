{ config, lib, pkgs, inputs, ... }:
let
  # {{{ Global extensions
  extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
    buster-captcha-solver
    # REASON: returns 404 for now
    # bypass-paywalls-clean
    clearurls # removes ugly args from urls
    cliget # Generates curl commands for downloading account-protected things
    don-t-fuck-with-paste # disallows certain websites from disabling pasting
    decentraleyes # Serves local copies of a bunch of things instead of reaching a CDN
    gesturefy # mouse gestures
    indie-wiki-buddy # redirects fandom wiki urls to the proper wikis
    i-dont-care-about-cookies
    localcdn # caches libraries locally
    privacy-badger # blocks some trackers
    privacy-pass # captcha stuff
    privacy-redirect # allows redirecting to my own instances for certain apps
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

    policies = {
      DisableAppUpdate = true;
      DisableBuiltinPDFViewer = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
    };

    profiles.adrielus = {
      # {{{ High level user settings
      # Unique user id
      id = 0;

      # Make this the default user
      isDefault = true;

      # Forcefully replace the search configuration
      search.force = true;
      search.default = "Moonythm";

      # Set styles applied to firefox itself
      userChrome = builtins.readFile ./userChrome.css;
      # }}}
      # {{{ Extensions
      extensions =
        with inputs.firefox-addons.packages.${pkgs.system};
        with lib.lists; flatten [
          extensions
          # List of profile-specific extensions
          [
            augmented-steam # Adds more info to steam
            bitwarden # Password manager
            blocktube # Lets you block youtube channels
            dearrow # Crowdsourced clickbait remover 💀
            leechblock-ng # website blocker
            lovely-forks # displays forks on github
            octolinker # github import to link thingy
            octotree # github file tree
            refined-github # a bunch of github modifications
            return-youtube-dislikes
            steam-database # adds info from steamdb on storepages
            sponsorblock # skip youtube sponsors
            vimium-c # vim keybinds
            youtube-shorts-block
          ]
        ];
      # }}}
      # {{{ Search engines
      search.engines =
        let
          # {{{ Search engine creation helpers
          mkBasicSearchEngine = { aliases, url, param, icon ? null }: {
            urls = [{
              template = url;
              params = [
                { name = param; value = "{searchTerms}"; }
              ];
            }];

            definedAliases = aliases;
          } // (if icon == null then { } else { inherit icon; });

          mkNixPackagesEngine = { aliases, type }:
            mkBasicSearchEngine
              {
                aliases = aliases;
                url = "https://search.nixos.org/${type}";
                param = "query";
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

          "Pursuit" = mkBasicSearchEngine {
            url = "https://pursuit.purescript.org/search";
            param = "q";
            aliases = [ "@ps" "@pursuit" ];
          };

          "Hoogle" = mkBasicSearchEngine {
            url = "https://hoogle.haskell.org";
            param = "hoogle";
            aliases = [ "@hg" "@hoogle" ];

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

          "Arcaea wiki" = mkBasicSearchEngine {
            url = "https://arcaea.fandom.com/wiki/Special:Search?scope=internal&navigationSearch=true";
            param = "query";
            aliases = [ "@ae" "@arcaea" ];
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

          "Arch wiki" = mkBasicSearchEngine {
            url = "https://wiki.archlinux.org/index.php";
            param = "search";
            aliases = [ "@aw" "@arch-wiki" ];
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

          "Moonythm" = mkBasicSearchEngine {
            url = "https://search.moonythm.dev/search";
            param = "q";
            aliases = [ "@m" "@moonythm" ];
            icon = ../../../../common/icons/whoogle.webp;
          };

          "Google".metaData.alias = "@g";
        };
      # }}}
      # }}}
      # {{{ Other lower level settings
      settings = {
        # Required for figma to be able to export to svg
        "dom.events.asyncClipboard.clipboardItem" = true;

        # Allow custom css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Set language to english
        "general.useragent.locale" = "en-GB";

        # Do not restore sessions after what looks like a "crash"
        "browser.sessionstore.resume_from_crash" = false;

        # Inspired by https://github.com/TLATER/dotfiles/blob/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix
        # {{{ Performance settings
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
        # }}}
        # {{{ New tab page 
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
          false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
          false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;
        # }}}
        # {{{ Privacy
        "browser.contentblocking.category" = "strict";
        "app.shield.optoutstudies.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.discovery.enabled" = false;
        # }}}

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Do not include "switch to [tab]" in search results
        "browser.urlbar.suggest.openpage" = false;

        # Hide random popup: https://forums.linuxmint.com/viewtopic.php?t=379164
        "browser.protections_panel.infoMessage.seen" = true;

        # Disable shortcut for quitting :)
        "browser.quitShortcut.disabled" = true;

        # Do not show dialog for getting panes in the addons menu (?)
        # http://kb.mozillazine.org/Extensions.getAddons.showPane
        "extensions.getAddons.showPane" = false;

        # Do not recommend addons
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
      };
      # }}}
    };

    # {{{ Standalone "apps" which actually run inside a browser.
    apps.extensions = extensions;
    apps.app = {
      # TODO: auto increment ids
      # {{{ Desmos
      desmos = {
        url = "https://www.desmos.com/calculator";
        icon = ../../../../common/icons/desmos.png;
        displayName = "Desmos";
        id = 1;
      };
      # }}}
      # {{{ Monkey type
      monkey-type = {
        url = "https://monkeytype.com/";
        icon = ../../../../common/icons/monkeytype.png;
        displayName = "Monkeytype";
        id = 2;
      };
      # }}}
      # {{{ Syncthing
      syncthing = {
        url = "http://localhost:8384/";
        icon = ../../../../common/icons/syncthing.png;
        displayName = "Syncthing";
        id = 3;
      };
      # }}}
    };
    # }}}
  };

  # TODO: uncomment when using newer version
  # stylix.targets.firefox = {
  #   enable = true;
  #   profileNames = [ "adrielus" "desmos" "monkey-type" "syncthing" ];
  # };

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
  satellite.persistence.at.state.apps.firefox.directories = [
    ".mozilla/firefox" # More important stuff
  ];

  satellite.persistence.at.cache.apps.firefox.directories = [
    "${config.xdg.cacheHome}/mozilla/firefox" # Non important cache
  ];
  # }}}
}

