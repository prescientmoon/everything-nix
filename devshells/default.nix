args: rec {
  bootstrap = import ./bootstrap/shell.nix args;
  satellite = import ./satellite.nix args;
}
