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
  satellite.persistence.at.cache.apps.rust.directories = [
    ".cargo"
    ".rustup"
  ];
  # }}}
  # {{{ Purescript
  satellite.persistence.at.cache.apps.purescript.directories = [
    "${config.xdg.dataHome}/purescript"
    "${config.xdg.cacheHome}/spago"
  ];
  # }}}
  # {{{ Nodejs
  satellite.persistence.at.cache.apps.nodejs = {
    files = [
      # Yarn auto-generated file
      ".yarnrc"
    ];

    directories = [
      # Node & npm
      "${config.xdg.cacheHome}/node-gyp"
      ".npm"

      # Yarn
      "${config.xdg.cacheHome}/yarn"

      # Pnpm
      "${config.xdg.cacheHome}/pnpm"
      "${config.xdg.dataHome}/pnpm"
      ".local/state/pnpm"
    ];
  };
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
    directories = [
      ".factorio" # TODO: perhaps this should have it's own file?

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
