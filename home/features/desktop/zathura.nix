# Zathura is the pdf reader I am using.
{ config, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = with config.lib.stylix.scheme.withHashtag; ''
      # {{{ Some arbitrary settings
      # Open document in fit-width mode by default
      set adjust-open "best-fit"

      # Inject font
      set font "${config.stylix.fonts.sansSerif.name}"
      # }}}
      # {{{ Default foreground/background color
      set default-bg rgba(${config.satellite.theming.colors.rgba "base00"})
      set default-fg ${base05}
      # }}}
      # {{{ Recolor
      set recolor 'true' # Allow recolor
      set recolor-keephue 'false' # Don't allow original hue when recoloring
      set recolor-reverse-video 'true' # Keep original image colors while recoloring

      # Represent light/dark colors in recoloring mode
      set recolor-lightcolor rgba(0,0,0,0)
      set recolor-darkcolor '${base05}'
      # }}}
      # {{{ Completion
      # Command line completion entries
      set completion-fg '${base05}'
      set completion-bg '${base00}'

      # Command line completion group elements
      set completion-group-fg '${base02}'
      set completion-group-bg '${base00}'

      # Current command line completion element
      set completion-highlight-fg '${base00}'
      set completion-highlight-bg '${base05}'
      # }}}
      # {{{ Input bar
      set inputbar-fg '${base05}'
      set inputbar-bg '${base00}'
      # }}}
      # {{{ Notifications
      set notification-fg '${base05}'
      set notification-bg '${base00}'

      # Error notification
      set notification-error-fg '${base08}'
      set notification-error-bg '${base01}'

      # Warning notification
      set notification-warning-fg '${base0A}'
      set notification-warning-bg '${base01}'
      # }}}
      # {{{ TODO: tabs
      # Tab
      # set tabbar-fg
      # set tabbar-bg

      # Focused tab
      # set tabbar-focus-fg
      # set tabbar-focus-bg
      # }}}
      # {{{ Status bar
      set statusbar-fg '${base05}'
      set statusbar-bg '${base00}'
      # }}}
      # {{{ Highlighting parts of the document (e.g. show search results)
      # TODO: make sure these look fine on other schemes
      set highlight-color '${base03}'
      set highlight-active-color '${base06}'
      # }}}
      # {{{ 'Loading...' text
      set render-loading-fg '${base05}'
      set render-loading-bg '${base00}'
      # }}}
      # {{{ Index mode
      set index-fg '${base05}'
      set index-bg 'rgba(0,0,0.0)'

      # Selected element in index mode
      set index-active-fg '${base07}'
      set index-active-bg '${base03}'
      # }}}
    '';
  };

  home.shellAliases.pdf = "zathura --fork";
}
