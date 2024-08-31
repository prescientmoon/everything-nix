{ config, ... }:
{
  sops.secrets.moonythm_mail_pass.sopsFile = ./secrets.yaml;

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email.accounts = {
    # {{{ Moonythm
    moonythm = rec {
      # {{{ Primary config
      address = "colimit@moonythm.dev";
      realName = "prescientmoon";
      userName = address;
      aliases = [ "hi@moonythm.dev" ];

      folders = {
        inbox = "Inbox";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
      };

      passwordCommand = "cat ${config.sops.secrets.moonythm_mail_pass.path}";
      primary = true;
      # }}}
      # {{{ Imap / smtp configuration
      imap = {
        host = "imap.migadu.com";
        port = 993;
      };

      smtp = {
        host = "smtp.migadu.com";
        port = 465;
      };
      # }}}
      # {{{ Auxilliary services
      msmtp = {
        enable = true;
      };

      mbsync = {
        enable = true;
        create = "both"; # sync folders both ways
        expunge = "maildir"; # Delete messages when the local dir says so
      };

      notmuch = {
        enable = true;
        neomutt.enable = true;
      };
      # }}}
      # {{{ Neomutt
      neomutt = {
        enable = true;
        sendMailCommand = "msmtpq --read-envelope-from --read-recipients";
        extraMailboxes = [
          "Archive"
          "Drafts"
          "Junk"
          "Sent"
          "Trash"
        ];
      };
      # }}}
      # {{{ Aerc
      aerc = {
        enable = true;
      };
      # }}}
    };
    # }}}
  };

  # {{{ Aerc
  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };
  # }}}
  # {{{ Neomutt
  programs.neomutt = {
    # {{{ Primary config
    enable = true;
    vimKeys = true;
    checkStatsInterval = 60; # How often to check for new mail
    sidebar = {
      enable = true;
      width = 30;
    };
    # }}}

    binds = [
      # {{{ Toggle sidebar
      {
        map = [
          "index"
          "pager"
        ];
        key = "B";
        action = "sidebar-toggle-visible";
      }
      # }}}
      # {{{ Highlight previous sidebar item
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\CK";
        action = "sidebar-prev";
      }
      # }}}
      # {{{ Highlight next sidebar item
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\CJ";
        action = "sidebar-next";
      }
      # }}}
      # {{{ Open highlighted sidebar item
      {
        map = [
          "index"
          "pager"
        ];
        key = "\\CO";
        action = "sidebar-open";
      }
      # }}}
    ];

    macros = [
      # {{{ Sync emails
      {
        map = [ "index" ];
        key = "S";
        action = "<shell-escape>mbsync -a<enter><shell-escape>notmuch new<enter>";
      }
      # }}}
      # # {{{ show only messages matching a notmuch pattern
      # {
      #   map = [ "index" ];
      #   key = "\\Cf";
      #   action = ''"<enter-command>unset wait_key<enter><shell-escape>read -p 'Enter a search term to find with notmuch: ' x;''
      #     + ''echo \\$x >~/.cache/mutt_terms<enter><limit>~i \\"\\`notmuch search - -output=messages \\$(cat ~/.cache/mutt_terms) ''
      #     + ''| head -n 600 | perl -le '@a=<>;s/\^ id:// for@a;$, = \\"|\\";print@a' | perl -le '@a=<>; chomp@a; s/\\\\+/\\\\\\\\+/ for@a;print@a' \`\\"<enter>"'';
      # }
      # # }}}
    ];

    extraConfig = ''
      # Starting point: https://seniormars.com/posts/neomutt/#introduction-and-why
      # {{{ Settings
      set pager_index_lines = 10
      set pager_context = 3                # show 3 lines of context
      set pager_stop                       # stop at end of message
      set menu_scroll                      # scroll menu
      set tilde                            # use ~ to pad mutt
      set move=no                          # don't move messages when marking as read
      set sleep_time = 0                   # don't sleep when idle
      set wait_key = no		     # mutt won't ask "press key to continue"
      set envelope_from                    # which from?
      # set edit_headers                     # show headers when composing
      set fast_reply                       # skip to compose when replying
      set askcc                            # ask for CC:
      set fcc_attach                       # save attachments with the body
      set forward_format = "Fwd: %s"       # format of subject when forwarding
      set forward_decode                   # decode when forwarding
      set forward_quote                    # include message in forwards
      set mime_forward                     # forward attachments as part of body
      set attribution = "On %d, %n wrote:" # format of quoting header
      set reply_to                         # reply to Reply to: field
      set reverse_name                     # reply as whomever it was to
      set include                          # include message in replies
      set text_flowed=yes                  # correct indentation for plain text
      unset sig_dashes                     # no dashes before sig
      unset markers
      # }}}
      # {{{ Sort by newest conversation first.
      set charset = "utf-8"
      set uncollapse_jump
      set sort_re
      set sort = reverse-threads
      set sort_aux = last-date-received
      # }}}
      # {{{ How we reply and quote emails.
      set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
      set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
      set send_charset = "utf-8:iso-8859-1:us-ascii" # send in utf-8
      # }}}
      # {{{ Sidebar
      set sidebar_visible # comment to disable sidebar by default
      set sidebar_short_path
      set sidebar_folder_indent
      set sidebar_format = "%B %* [%?N?%N / ?%S]"
      set mail_check_stats
      # }}}
      # {{{ Theme
      # From: https://github.com/altercation/mutt-colors-solarized/blob/master/mutt-colors-solarized-dark-16.muttrc
      # basic colors ---------------------------------------------------------
      color normal        brightyellow    default
      color error         red             default
      color tilde         black           default
      color message       cyan            default
      color markers       red             white
      color attachment    white           default
      color search        brightmagenta   default
      color status        brightyellow    black
      color indicator     brightblack     yellow
      color tree          cyan            default                                     # arrow in threads

      # basic monocolor screen
      mono  bold          bold
      mono  underline     underline
      mono  indicator     reverse
      mono  error         bold

      # index ----------------------------------------------------------------

      color index         red             default         "~A"                        # all messages
      color index         blue            default         "~N"                        # new messages
      color index         brightred       default         "~E"                        # expired messages
      color index         blue            default         "~N"                        # new messages
      color index         blue            default         "~O"                        # old messages
      color index         brightmagenta   default         "~Q"                        # messages that have been replied to
      color index         brightgreen     default         "~R"                        # read messages
      color index         blue            default         "~U"                        # unread messages
      color index         blue            default         "~U~$"                      # unread, unreferenced messages
      color index         cyan            default         "~v"                        # messages part of a collapsed thread
      color index         magenta         default         "~P"                        # messages from me
      color index         cyan            default         "~p!~F"                     # messages to me
      color index         cyan            default         "~N~p!~F"                   # new messages to me
      color index         cyan            default         "~U~p!~F"                   # unread messages to me
      color index         brightgreen     default         "~R~p!~F"                   # messages to me
      color index         red             default         "~F"                        # flagged messages
      color index         red             default         "~F~p"                      # flagged messages to me
      color index         red             default         "~N~F"                      # new flagged messages
      color index         red             default         "~N~F~p"                    # new flagged messages to me
      color index         red             default         "~U~F~p"                    # new flagged messages to me
      color index         brightcyan      default         "~v~(!~N)"                  # collapsed thread with no unread
      color index         yellow          default         "~v~(~N)"                   # collapsed thread with some unread
      color index         green           default         "~N~v~(~N)"                 # collapsed thread with unread parent
      color index         red             black           "~v~(~F)!~N"                # collapsed thread with flagged, no unread
      color index         yellow          black           "~v~(~F~N)"                 # collapsed thread with some unread & flagged
      color index         green           black           "~N~v~(~F~N)"               # collapsed thread with unread parent & flagged
      color index         green           black           "~N~v~(~F)"                 # collapsed thread with unread parent, no unread inside, but some flagged
      color index         cyan            black           "~v~(~p)"                   # collapsed thread with unread parent, no unread inside, some to me directly
      color index         yellow          red             "~v~(~D)"                   # thread with deleted (doesn't differentiate between all or partial)
      color index         yellow          default         "~(~N)"                     # messages in threads with some unread
      color index         green           default         "~S"                        # superseded messages
      color index         black           red             "~D"                        # deleted messages
      color index         black           red             "~N~D"                      # deleted messages
      color index         red             default         "~T"                        # tagged messages

      # message headers ------------------------------------------------------

      color hdrdefault    brightgreen     default
      color header        brightyellow    default         "^(From)"
      color header        blue            default         "^(Subject)"

      # body -----------------------------------------------------------------

      color quoted        blue            default
      color quoted1       cyan            default
      color quoted2       yellow          default
      color quoted3       red             default
      color quoted4       brightred       default

      color signature     brightgreen     default
      color bold          black           default
      color underline     black           default
      color normal        default         default
      color body          brightcyan      default         "[;:][-o][)/(|]"    # emoticons
      color body          brightcyan      default         "[;:][)(|]"         # emoticons
      color body          brightcyan      default         "[*]?((N)?ACK|CU|LOL|SCNR|BRB|BTW|CWYL|\
                                                           |FWIW|vbg|GD&R|HTH|HTHBE|IMHO|IMNSHO|\
                                                           |IRL|RTFM|ROTFL|ROFL|YMMV)[*]?"
      color body          brightcyan      default         "[ ][*][^*]*[*][ ]?" # more emoticon?
      color body          brightcyan      default         "[ ]?[*][^*]*[*][ ]" # more emoticon?

      ## pgp

      color body          red             default         "(BAD signature)"
      color body          cyan            default         "(Good signature)"
      color body          brightblack     default         "^gpg: Good signature .*"
      color body          brightyellow    default         "^gpg: "
      color body          brightyellow    red             "^gpg: BAD signature from.*"
      mono  body          bold                            "^gpg: Good signature"
      mono  body          bold                            "^gpg: BAD signature from.*"

      # yes, an insance URL regex
      color body          red             default         "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
      # and a heavy handed email regex
      color body          magenta        default         "((@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]),)*@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]):)?[0-9a-z_.+%$-]+@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\])"

      # Various smilies and the like
      color body          brightwhite     default         "<[Gg]>"                            # <g>
      color body          brightwhite     default         "<[Bb][Gg]>"                        # <bg>
      color body          yellow          default         " [;:]-*[})>{(<|]"                  # :-) etc...
      # *bold*
      color body          blue            default         "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
      mono  body          bold                            "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
      # _underline_
      color body          blue            default         "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
      mono  body          underline                       "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
      # /italic/  (Sometimes gets directory names)
      color body         blue            default         "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
      mono body          underline                       "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"

      # Border lines.
      color body          blue            default         "( *[-+=#*~_]){6,}"

      # From https://github.com/jessfraz/dockerfiles/blob/master/mutt/.mutt/mutt-patch-highlighting.muttrc
      color   body    cyan            default         ^(Signed-off-by).*
      color   body    cyan            default         ^(Docker-DCO-1.1-Signed-off-by).*
      color   body    brightwhite     default         ^(Cc)
      color   body    yellow          default         "^diff \-.*"
      color   body    brightwhite     default         "^index [a-f0-9].*"
      color   body    brightblue      default         "^---$"
      color   body    white           default         "^\-\-\- .*"
      color   body    white           default         "^[\+]{3} .*"
      color   body    green           default         "^[\+][^\+]+.*"
      color   body    red             default         "^\-[^\-]+.*"
      color   body    brightblue      default         "^@@ .*"
      color   body    green           default         "LGTM"
      color   body    brightmagenta   default         "-- Commit Summary --"
      color   body    brightmagenta   default         "-- File Changes --"
      color   body    brightmagenta   default         "-- Patch Links --"
      # }}}
    '';
  };

  # {{{ Neomutt desktop entry
  # Taken from here: https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/productivity/neomutt.nix
  xdg = {
    desktopEntries = {
      neomutt = {
        name = "Neomutt";
        genericName = "Email Client";
        comment = "Read and send emails";
        exec = "neomutt %U";
        icon = "mutt";
        terminal = true;
        categories = [
          "Network"
          "Email"
          "ConsoleOnly"
        ];
        type = "Application";
        mimeType = [ "x-scheme-handler/mailto" ];
      };
    };
    mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "neomutt.desktop";
    };
  };
  # }}}
  # }}}
  # {{{ Storage & persistence
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";
  satellite.persistence.at.data.apps.mail.directories = [ config.accounts.email.maildirBasePath ];
  # }}}
}
