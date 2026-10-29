{
  # This one brings our custom packages from the 'pkgs' directory...
  # I'm planning to remove that, but I'm lazy :p
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
