{ config, pkgs, ... }: {
  home.packages =
    let
      vaultDir = "${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}/stellar-sanctum";
      # Start nvim with a custom class so our WM can move it to the correct workspace
      obsidiantui = pkgs.writeShellScriptBin "obsidiantui" ''
        wezterm start --class "org.wezfurlong.wezterm.obsidian" --cwd ${vaultDir} nvim
      '';
    in
    [ obsidiantui pkgs.obsidian ];

  xdg.desktopEntries.obsidiantui = {
    name = "Obsidian TUI";
    type = "Application";
    exec = "obsidiantui";
    terminal = false;
    icon = "obsidian";
  };
}
