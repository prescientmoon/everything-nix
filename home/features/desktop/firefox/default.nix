{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.firefox = {
    enable = true;

    # {{{ Policies
    policies = {
      DisableAppUpdate = true;
      DisableBuiltinPDFViewer = true;
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
    # }}}

    profiles.${config.home.username} = {
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
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        # bypass-paywalls-clean # REASON: returns 404 for now
        augmented-steam # Adds more info to steam
        bitwarden # Password manager
        blocktube # Lets you block youtube channels
        buster-captcha-solver
        clearurls # removes ugly args from urls
        cliget # Generates curl commands for downloading account-protected things
        dearrow # Crowdsourced clickbait remover 💀
        decentraleyes # Serves local copies of a bunch of things instead of reaching a CDN
        don-t-fuck-with-paste # disallows certain websites from disabling pasting
        gesturefy # mouse gestures
        i-dont-care-about-cookies
        indie-wiki-buddy # redirects fandom wiki urls to the proper wikis
        leechblock-ng # website blocker
        localcdn # caches libraries locally
        # octolinker # github import to link thingy # REASON: 404 for now
        privacy-badger # blocks some trackers
        privacy-pass # captcha stuff
        privacy-redirect # allows redirecting to my own instances for certain apps
        refined-github # a bunch of github modifications
        return-youtube-dislikes
        skip-redirect # attempts to skip to the final reddirect for certain urls
        sponsorblock # skip youtube sponsors
        steam-database # adds info from steamdb on storepages
        terms-of-service-didnt-read
        translate-web-pages
        ublock-origin
        unpaywall
        user-agent-string-switcher
        vimium-c # vim keybinds
        youtube-shorts-block
      ];
      # }}}
      # {{{ Search engines
      search.engines =
        let
          mkBasicSearchEngine =
            {
              aliases,
              url,
              param,
              icon,
            }:
            {
              inherit icon;
              definedAliases = aliases;
              urls = [
                {
                  template = url;
                  params = [
                    {
                      name = param;
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
        in
        {
          "google".metaData.alias = "@g";
        }
        // lib.attrsets.mapAttrs (_: mkBasicSearchEngine) (lib.importTOML ./engines.toml);
      # }}}
      # {{{ Other lower level settings
      settings = {
        # Auto enable nix provided extensions
        "extensions.autoDisableScopes" = 0;

        # Required for Figma to be able to export to SVG
        "dom.events.asyncClipboard.clipboardItem" = true;

        # Allow custom CSS
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Set language to English
        "general.useragent.locale" = "en-GB";

        # Do not restore sessions after what looks like a "crash". Note that
        # said tabs can still be recovered manually with Control+Shift+Tab.
        "browser.sessionstore.resume_from_crash" = false;

        # Do not paste with middle mouse click
        "middlemouse.paste" = false;

        # Do not include "switch to [tab]" in search results
        "browser.urlbar.suggest.openpage" = false;

        # Disable shortcut for quitting :)
        "browser.quitShortcut.disabled" = true;

        # Keep the reader button enabled at all times; really don't
        # care if it doesn't work 20% of the time, most websites are
        # crap and unreadable without this
        "reader.parse-on-load.force-enabled" = true;

        # Hide the "sharing indicator", it's especially annoying
        # with tiling WMs on wayland
        "privacy.webrtc.legacyGlobalIndicator" = false;

        # Hide random popup:
        # https://forums.linuxmint.com/viewtopic.php?t=379164
        "browser.protections_panel.infoMessage.seen" = true;

        # Do not show dialog for getting panes in the add-ons menu (?)
        # http://kb.mozillazine.org/Extensions.getAddons.showPane
        "extensions.getAddons.showPane" = false;

        # Do not recommend add-ons
        "extensions.htmlaboutaddons.recommendations.enabled" = false;

        # Disable the ML stuff
        "browser.ml.enable" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.shortcuts" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;

        # Inspired by https://github.com/TLATER/dotfiles/blob/b39af91fbd13d338559a05d69f56c5a97f8c905d/home-config/config/graphical-applications/firefox.nix
        # Performance settings
        "gfx.webrender.all" = true; # Force enable GPU acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true; # Required in recent versions

        # New tab page
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.pinned" = false;

        # Privacy
        "browser.contentblocking.category" = "strict";
        "app.shield.optoutstudies.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.discovery.enabled" = false;
      };
      # }}}
    };
  };

  stylix.targets.firefox = {
    enable = true;
    profileNames = [ config.home.username ];
  };

  # {{{ Make Firefox the default browser
  # Use Firefox as the default browser to open stuff.
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  # Tell apps Firefox is the default browser using an environment variable.
  home.sessionVariables.BROWSER = "firefox";
  # }}}
  # {{{ Persistence
  satellite.persistence.at.state.apps.firefox.directories = [
    ".mozilla/firefox" # More important stuff
  ];

  satellite.persistence.at.cache.apps.firefox.directories = [
    "${config.xdg.cacheHome}/mozilla/firefox" # Non-important cache
  ];
  # }}}
}
