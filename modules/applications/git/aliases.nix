# Most of these are copied from: https://github.com/Brettm12345/nixos-config/blob/1400c71bce/modules/applications/git/aliases.nix

let
  git = text: ''"!git ${text}"'';
  f = text: ''"!f(){ ${text} };f"'';
in {
  # Unstage all changes
  unstage = "reset HEAD --";

  # Ammend to the last commit
  amend = "commit --amend -C HEAD";

  # List branches sorted by last modified
  b = git
    "for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'";

  # Test merge for conflicts before merging
  mergetest = f ''
    git merge --no-commit --no-ff "$1"; git merge --abort; echo "Merge aborted";'';

  # Get description of current repo
  description = git
    ''config --get "branch.$(git rev-parse --abbrev-ref HEAD).description"'';

  # Show authors
  authors = ''
    "!f() { git log --no-merges --pretty='format:%<(26)%an <%ae>' --author "$*" | sort | uniq# }# f"'';

  a = "add";
  cm = "commit --message";
  caa = "commit --ammend";
  cl = "clone";
  co = "checkout";
  col = "checkout @{-1}";
  cob = "checkout -b";
  st = "stash";
  pop = "stash pop";
  t = "tag";
}
