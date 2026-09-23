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

    satellite.persistence.at.state.directories = [ "/var/lib/iwd" ];

    sops.secrets.eduroam_config.sopsFile = ../secrets.yaml;
    sops.templates."eduroam.8021x".content = ''
      [Security]
      EAP-Method=PEAP
      EAP-Identity=anonymous@ru.nl
      EAP-PEAP-Phase2-Method=MSCHAPV2
      ${config.sops.placeholder.eduroam_config}

      [Settings]
      AutoConnect=true
    '';

    systemd.tmpfiles.rules = [
      "L+ /persist/state/var/lib/iwd/eduroam.8021x - - - - ${config.sops.templates."eduroam.8021x".path}"
    ];

    systemd.services.iwd = lib.mkIf (!cfg.active) {
      wantedBy = lib.mkForce [ ];
    };
  };
}
