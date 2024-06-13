{
  imports = [ ./acme.nix ];
  satellite.nginx.domain = "moonythm.dev"; # Root domain used throughout my config
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true; # Necessary for prometheus exporter
  };
}
