{ config, pkgs, ... }: {
  home.packages = [ pkgs.obsidian ];

  # Start nvim with a custom class so our WM can move it to the correct workspace
  xdg.desktopEntries.obsidiantui = {
    name = "Obsidian TUI";
    type = "Application";
    icon = "obsidian";
    terminal = false;
    exec =
      let vaultDir = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/stellar-sanctum";
      in
      builtins.toString (pkgs.writeShellScript "obsidiantui" ''
        wezterm start --class "org.wezfurlong.wezterm.obsidian" --cwd ${vaultDir} nvim
      '');
  };
}
