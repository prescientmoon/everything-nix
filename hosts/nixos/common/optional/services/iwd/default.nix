{ config, ... }:
{
  networking.wireless.iwd = {
    enable = true;

    settings = {
      IPv6.Enabled = true;
      Settings.AutoConnect = true;
    };
  };

  environment.persistence."/persist/state".directories = [ "/var/lib/iwd" ];

  sops.templates."eduroam.8021x".path = "/var/lib/iwd/eduroam.8021x";
  sops.secrets.eduroam_pass.sopsFile = ../../../secrets.yaml;
  sops.templates."eduroam.8021x".content = ''
    [Security]
    EAP-Method=PEAP
    EAP-Identity=s5260329@rug.nl
    EAP-PEAP-CACert=${./eduroam.pem}
    EAP-PEAP-Phase2-Method=MSCHAPV2
    EAP-PEAP-Phase2-Identity=s5260329@rug.nl
    EAP-PEAP-Phase2-Password=${config.sops.placeholder.eduroam_pass}
    EAP-PEAP-ServerDomainMask=radius.rug.nl

    [Settings]
    AutoConnect=true
  '';
}
