{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    userName = "Matei Adriel";
    userEmail = "rafaeladriel11@gmail.com";

    ignores = [
      # Syncthing
      ".stfolder"
      ".stversions"

      # Direnv
      ".direnv"
      ".envrc"

      # Haskell
      # NOTE: THIS IS A BAD IDEA
      # I need to figure out a better way (this is simply here because
      # a project I contribute to doesn't gitignore this file, nor does
      # it have it commited).
      "hie.yaml"
    ];

    aliases = {
      # Print history nicely
      graph = "log --decorate --oneline --graph";

      # Print last commit's hash
      hash = "log -1 --format='%H'";
    };

    extraConfig = {
      github.user = "Mateiadrielrafael";
      hub.protocol = "ssh";
      core.editor = "nvim";
      init.defaultBranch = "main";
      rebase.autoStash = true;

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
