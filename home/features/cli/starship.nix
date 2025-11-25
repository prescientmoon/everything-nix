{
  programs.starship = {
    enable = true;
    settings = {
      git_status.disabled = true; # Do not show the git status (slow!)
      package.disabled = true; # Do not show the version of the current package
      rust.disabled = true; # Do not show Rust's version
    };
  };
}
