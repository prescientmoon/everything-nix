{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    aliases.graph = "log --decorate --oneline --graph";

    userName = "Matei Adriel";
    userEmail = "rafaeladriel11@gmail.com";

    ignores = [
      # Syncthing
      ".stfolder"
      ".stversions"
      # Direnv
      ".direnv"
    ];

    extraConfig = {
      github.user = "Mateiadrielrafael";
      hub.protocol = "ssh";
      core.editor = "nvim";
      rebase.autoStash = true;
      init.defaultBranch = "main";

      # Sign commits using ssh
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";

      # Sign everything by default
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };

  # Github cli
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
