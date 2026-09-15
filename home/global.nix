{
  inputs,
  lib,
  config,
  ...
}:
{
  # Import all modules defined in modules/home-manager
  imports = lib.attrValues (import ../modules/common) ++ [
    inputs.stylix.homeModules.stylix
    inputs.sops-nix.homeManagerModules.sops

    ./features/cli
    ./features/persistence.nix
    ./features/dev.nix
    ../common
  ];

  # {{{ Enable the home-manager and git clis
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
  # }}}
  # {{{ Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "moon";
    homeDirectory = "/home/${config.home.username}";
  };
  # }}}
  # {{{ Ad-hoc settings
  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkForce "sd-switch";

  # Enable default application management
  xdg.mimeApps.enable = true;

  # Tell sops-nix to use ssh keys for decrypting secrets
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  # By default the paths given by sops contain annoying %r sections
  sops.defaultSymlinkPath = "${config.home.homeDirectory}/.nix-sops";

  #  Ad-hoc stylix targets
  stylix.targets.xresources.enable = true;
  # }}}
  # {{{ Xdg user directories
  # Set the xdg env vars
  xdg.enable = true;

  xdg.userDirs = {
    enable = lib.mkDefault true;
    createDirectories = lib.mkDefault false;
    setSessionVariables = true;

    desktop = null;
    templates = null;
    download = "${config.home.homeDirectory}/downloads";
    publicShare = "${config.home.homeDirectory}/public";
    music = "${config.home.homeDirectory}/media/music";
    pictures = "${config.home.homeDirectory}/media/pictures";
    videos = "${config.home.homeDirectory}/media/videos";
    documents = "${config.home.homeDirectory}/media/documents";

    extraConfig.SCREENSHOTS = "${config.xdg.userDirs.pictures}/screenshots";
    extraConfig.PROJECTS = "${config.home.homeDirectory}/projects";
  };

  systemd.user.tmpfiles.rules = [
    # Clean screenshots older than a week
    "d ${config.xdg.userDirs.extraConfig.SCREENSHOTS} - - - 7d"
  ];

  # Don't make the dev symlinks go through the bind mounts for no reason!
  satellite.dev.root = "/persist/data${config.xdg.userDirs.extraConfig.PROJECTS}/personal/satellite";
  # }}}
}
