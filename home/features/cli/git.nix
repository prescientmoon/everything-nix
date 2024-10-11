{ config, pkgs, ... }:
{
  home.packages = [ pkgs.josh ]; # Just One Single History

  # TODO: use `delta` as a pager, as highlighted here
  # https://github.com/lilyinstarlight/foosteros/blob/main/config/base.nix#L163
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    userName = "prescientmoon";
    userEmail = "git@moonythm.dev";

    # {{{ Globally ignored files
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
    # }}}
    # {{{ Aliases
    aliases = {
      # Print history nicely
      graph = "log --decorate --oneline --graph";

      # Print last commit's hash
      hash = "log -1 --format='%H'";

      # Count the number of commits
      count = "rev-list --count --all";
    };
    # }}}

    extraConfig = {
      github.user = "prescientmoon";
      hub.protocol = "ssh";
      core.editor = "nvim";
      init.defaultBranch = "main";
      rebase.autoStash = true;

      push.default = "current";
      push.autoSetupRemote = true;

      #  {{{ URL rewriting
      url."git@github.com:".insteadOf = [
        # Normalize GitHub URLs to SSH to avoid authentication issues with HTTPS.
        # "https://github.com/"

        # Allows typing `git clone github:owner/repo`.
        "github:"
      ];
      #  }}}
      # {{{ Signing
      # Sign commits using ssh
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";

      # Sign everything by default
      commit.gpgsign = true;
      tag.gpgsign = true;
      # }}}
    };
  };

  # {{{ Github cli
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  satellite.persistence.at.state.apps.gh.files = [ "${config.xdg.configHome}/gh/hosts.yml" ];
  # }}}
}
