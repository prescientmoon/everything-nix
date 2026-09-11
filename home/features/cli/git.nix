{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.josh # Just One Single History
    (pkgs.writeShellScriptBin "git-large-files" ''
      git rev-list --objects --all --missing=print \
      | git cat-file \
          --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
      | sed -n 's/^blob //p' \
      | sort --numeric-sort --key=2 \
      | cut -c 1-12,41- \
      | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest \
      | $PAGER
    '')
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;

    # {{{ Globally ignored files
    ignores = [
      # Syncthing
      ".stfolder"
      ".stversions"

      # Direnv
      ".direnv"
      ".envrc"

      # Nix
      "result"
      ".nixos-test-history"

      # Haskell
      # NOTE: THIS IS A BAD IDEA
      # I need to figure out a better way (this is simply here because
      # a project I contribute to doesn't git-ignore this file, nor does
      # it have it committed).
      "hie.yaml"
    ];
    # }}}

    settings = {
      user.name = "prescientmoon";
      user.email = "git@moonythm.dev";

      github.user = "prescientmoon";
      hub.protocol = "ssh";
      core.editor = "nvim";
      init.defaultBranch = "main";
      rebase.autoStash = true;

      push.default = "current";
      push.autoSetupRemote = true;

      # URL rewriting
      url."git@github.com:".insteadOf = [
        # Normalize GitHub URLs to SSH to avoid authentication issues with HTTPS.
        # I ended up disabling this, but I forgot why...
        # "https://github.com/"

        # Allows typing `git clone github:owner/repo`.
        "github:"
      ];

      url."forgejo@lapetus.overlay.moonythm.dev:".insteadOf = [
        # Allows typing `git clone moonythm:owner/repo`.
        "moonythm:"
      ];

      # Sign commits using ssh
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";

      # Sign everything by default
      commit.gpgsign = true;
      tag.gpgsign = true;

      # Aliases
      alias = {
        # Print history nicely
        graph = "log --decorate --oneline --graph";

        # Print last commit' hash
        hash = "log -1 --format='%H'";

        # Count the number of commits
        count = "rev-list --count --all";
      };
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  satellite.persistence.at.state.apps.gh.files = [ "${config.xdg.configHome}/gh/hosts.yml" ];
}
