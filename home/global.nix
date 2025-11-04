{
  inputs,
  lib,
  config,
  outputs,
  ...
}:
let
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.sops-nix.homeManagerModules.sops

    ./features/cli
    ./features/persistence.nix
    ../common
  ];
in
{
  # Import all modules defined in modules/home-manager
  imports = builtins.attrValues outputs.homeManagerModules ++ imports;

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

    desktop = null;
    templates = null;
    download = "${config.home.homeDirectory}/downloads";
    publicShare = "${config.home.homeDirectory}/public";
    music = "${config.home.homeDirectory}/media/music";
    pictures = "${config.home.homeDirectory}/media/pictures";
    videos = "${config.home.homeDirectory}/media/videos";
    documents = "${config.home.homeDirectory}/media/documents";

    extraConfig.XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
    extraConfig.XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
  };

  systemd.user.tmpfiles.rules = [
    # Clean screenshots older than a week
    "d ${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR} - - - 7d"
  ];
  # }}}
}
