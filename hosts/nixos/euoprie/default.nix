{
  privateNetwork = true;
  hostAddress = "10.250.0.1";
  localAddress = "10.250.0.2";

  config = import ./configuration.nix;
}
