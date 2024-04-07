{
  imports = [ ./acme.nix ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true; # Necessary for prometheus exporter
  };
}
