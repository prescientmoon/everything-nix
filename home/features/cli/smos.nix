{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # NOTE: using `pkgs.system` before `module.options` is evaluated
    # leads to infinite recursion! I should perhaps take system as
    # a special argument as well...
    inputs.smos.homeManagerModules.x86_64-linux.default
  ];

  programs.smos = {
    workflowDir =
      let
        projects = config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR;
      in
      "${projects}/personal/stellar-sanctum/smos";

    # We don't want to use the statically-linked binary, as it requires
    # pulling-in the entirety of `ghc-musl`.
    smosReleasePackages = inputs.smos.packages.${pkgs.system}.default;

    enable = true;
    notify.enable = true;
  };

  # Storage
  satellite.persistence.at.data.apps.smos.directories = [
    config.programs.smos.workflowDir
  ];

  # Desktop entry — start Smos with a custom class so our WM can move it to the
  # correct workspace.
  xdg.desktopEntries.smostui = {
    name = "Smos TUI";
    type = "Application";
    terminal = false;
    icon = ../../../common/icons/smos.svg;
    exec = builtins.toString (
      pkgs.writeShellScript "smostui" ''
        foot -a Smos -D ${config.programs.smos.workflowDir} smos
      ''
    );
  };
}
