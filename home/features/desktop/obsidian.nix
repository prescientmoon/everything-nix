{ config, pkgs, ... }:
{
  # Start neovim with a custom class so our WM can automatically move it to the
  # correct workspace.
  xdg.desktopEntries.obsidiantui = {
    name = "Obsidian TUI";
    type = "Application";
    icon = "obsidian";

    terminal = false;
    exec =
      let
        projects = config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR;
        vaultDir = "${projects}/personal/stellar-sanctum";
      in
      toString (
        pkgs.writeShellScript "obsidiantui" ''
          foot -a Obsidian -D ${vaultDir} nvim
        ''
      );
  };
}
