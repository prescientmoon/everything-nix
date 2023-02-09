{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      battery = "acpi";
      cat = "bat";
    };

    plugins = with pkgs.fishPlugins; [
      # Jump to directories by typing "z <directory-name>"
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
        };
      }
    ];

    interactiveShellInit = builtins.readFile ./config.fish;
  };
}
