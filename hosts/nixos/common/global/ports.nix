# The idea is to always use consecutive ports, but never go back and try to
# recycle older no longer used ports (for the sake of keeping things clean).
{
  satellite.ports = {
    whoogle = 8401;
    intray-api = 8402;
    intray-client = 8403;
    smos-docs = 8404;
    smos-api = 8405;
    smos-client = 8406;
    vaultwarden = 8407;
    actual = 8408;
    grafana = 8409;
    prometheus = 8410;
    prometheus-node-exporter = 8411;
    prometheus-nginx-exporter = 8412;
    commafeed = 8413;
    invidious = 8414;
    radicale = 8415;
    redlib = 8416;
    qbittorrent = 8417;
    microbin = 8418;
    forgejo = 8419;
    jupyterhub = 8420;
    guacamole = 8421;
    syncthing = 8422;
  };
}
