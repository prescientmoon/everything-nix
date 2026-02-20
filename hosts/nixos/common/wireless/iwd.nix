{ config, lib, ... }:
let
  cfg = config.satellite.wireless;
in
{
  config = lib.mkIf (cfg.enable && cfg.backend == "iwd") {
    networking.wireless.iwd = {
      enable = true;

      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
        # I love buggy WiFi chip firmware, yum! 😋
        # I love this WiFi chip being soldered onto my laptop! (so true)
        # They say Hitler is still alive (he supposedly time traveled to the
        # future), and the proof is right here, in this very WiFi chip. They say
        # every MediaTek MT7902 WiFi chip contains two drops of Hitler's blood,
        # and after having to deal with it, I'm starting to believe it (there's
        # no other way a single WiFi chip could be so annoying).
        #
        # (ignore me, I'm currently sleep deprived and my laptop is hurting my
        # feelings)
        DriverQuirks.PowerSaveDisable = "*";
      };
    };

    environment.persistence."/persist/state".directories = [ "/var/lib/iwd" ];

    sops.secrets.eduroam_pass.sopsFile = ../secrets.yaml;
    sops.templates."eduroam.8021x".content = ''
      [Security]
      EAP-Method=PEAP
      EAP-Identity=s5260329@rug.nl
      EAP-PEAP-CACert=${./eduroam.pem}
      EAP-PEAP-Phase2-Method=MSCHAPV2
      EAP-PEAP-Phase2-Identity=adriel.matei@ru.nl
      EAP-PEAP-Phase2-Password=${config.sops.placeholder.eduroam_pass}

      [Settings]
      AutoConnect=true
    '';
    # EAP-PEAP-ServerDomainMask=radius.ru.nl

    systemd.tmpfiles.rules = [
      "L+ /persist/state/var/lib/iwd/eduroam.8021x - - - - ${config.sops.templates."eduroam.8021x".path}"
    ];

    systemd.services.iwd = lib.mkIf (!cfg.active) {
      wantedBy = lib.mkForce [ ];
    };
  };
}
