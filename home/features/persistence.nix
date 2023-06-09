{ config, ... }: {
  # {{{ XDG dirs
  # The lack of "~/Desktop" and "~/Downloads" is intentional!
  satellite.persistence.at.data.apps.main.directories = [
    config.xdg.userDirs.documents
    config.xdg.userDirs.pictures
    config.xdg.userDirs.music
    config.xdg.userDirs.videos
    "Projects"
  ];
  # }}}
  # {{{ OpenTabletDriver
  satellite.persistence.at.state.apps.OpenTabletDriver.directories = [
    #"${config.xdg.configHome}/OpenTabletDriver"
  ];
  # }}}
  # {{{ Rust
  satellite.persistence.at.cache.apps.Rust.directories = [
    #".cargo"
    #".rustup"
  ];
  # }}}
  # {{{ Purescript
  satellite.persistence.at.cache.apps.Purescript.directories = [
    #"${config.xdg.cacheHome}/spago"
  ];
  # }}}
  # {{{ Nodejs
  satellite.persistence.at.cache.apps.Node.directories = [
    #"${config.xdg.cacheHome}/yarn"
    #"${config.xdg.dataHome}/pnpm"
  ];
  # }}}
  # {{{ Shell stuff
  satellite.persistence.at.cache.apps.Shell.directories = [
    #"${config.xdg.dataHome}/fish"
    #"${config.xdg.dataHome}/z" # The z fish plugin
    #"${config.xdg.dataHome}/direnv/allow"
    #".tmux"
  ];
  # }}}
  # {{{ Neovim
  satellite.persistence.at.cache.apps.Neovim.directories = [
  #  "${config.xdg.dataHome}/nvim"
  ];
  # }}}
  # {{{ SSH
  satellite.persistence.at.state.apps.Ssh.directories = [
  #  ".ssh"
  ];
  # }}}
  # {{{ QBittorrent
  satellite.persistence.at.state.apps.QBittorrent.directories = [
    "${config.xdg.configHome}/qBittorrent" # Config options
  ];

  satellite.persistence.at.cache.apps.QBittorrent.directories = [
    # TODO: investigate which subdirectories/files I actually want to keep
    "${config.xdg.dataHome}/qBittorrent" # Torrent files, logs, etc
  ];
  # }}}
  # {{{ Signal
  satellite.persistence.at.state.apps.Signal.directories = [
    "${config.xdg.configHome}/Signal" # Why tf does signal store it's state here 💀
  ];
  # }}}
  # {{{ Steam
  satellite.persistence.at.state.apps.Steam = {
    files = [
      ".steam/registry.vdf" # It seems like auto-login does not work without this
    ];

    directories = [
      ".factorio" # TODO: perhaps this should leave in it's own file?

      # A couple of games don't play well with bindfs
      {
        directory = "${config.xdg.dataHome}/Steam";
        method = "symlink";
      }
    ];
  };
  # }}}
  # {{{ Lutris
  # TODO: there might be more to cache in .cache/lutris
  satellite.persistence.at.state.apps.Lutris.directories = [
    "${config.xdg.configHome}/lutris" # General config data
    "${config.xdg.cacheHome}/lutris/banners" # Game banners
    "${config.xdg.cacheHome}/lutris/coverart" # Game cover art

    # Aparently IO intensive stuff like games prefer symlinks?
    { directory = "Games/Lutris"; method = "symlink"; } # Lutris games
  ];
  # }}}
  # {{{ Wine
  satellite.persistence.at.state.apps.Wine.directories = [ ".wine" ];
  # }}}
}
