# DNS entries which do not belong to a particular host
{ lib, ... }:
let
  # {{{ Website helpers
  ghPage = at: [
    {
      inherit at;
      type = "CNAME";
      value = "prescientmoon.github.io.";
    }
  ];

  picoSh = at: to: [
    {
      inherit at;
      type = if at == "" then "ALIAS" else "CNAME";
      value = "pgs.sh.";
    }
    {
      at = if at == "" then "_pgs" else "_pgs.${at}";
      type = "TXT";
      value = "prescientmoon-${to}";
    }
  ];
  # }}}
  # {{{ Migadu mail DNS setup
  migaduMail =
    at: verifyKey:
    let
      atPrefix = prefix: if at == "" then prefix else "${prefix}.${at}";
      atSuffix = suffix: if at == "" then suffix else "${at}.${suffix}";
    in
    [
      {
        inherit at;
        ttl = 600;
        type = "MX";
        value = [
          {
            exchange = "aspmx1.migadu.com.";
            preference = 10;
          }
          {
            exchange = "aspmx2.migadu.com.";
            preference = 20;
          }
        ];
      }
      {
        inherit at;
        ttl = 600;
        type = "TXT";
        value = [
          "v=spf1 include:spf.migadu.com -all"
          "hosted-email-verify=${verifyKey}"
        ];
      }
      {
        at = atPrefix "_dmarc";
        type = "TXT";
        value = ''v=DMARC1\; p=quarantine\;'';
        ttl = 600;
      }
      {
        at = atPrefix "key1._domainkey";
        type = "CNAME";
        value = "key1.${atSuffix "moonythm.dev"}._domainkey.migadu.com.";
        ttl = 600;
      }
      {
        at = atPrefix "key2._domainkey";
        type = "CNAME";
        value = "key2.${atSuffix "moonythm.dev"}._domainkey.migadu.com.";
        ttl = 600;
      }
      {
        at = atPrefix "key3._domainkey";
        type = "CNAME";
        value = "key3.${atSuffix "moonythm.dev"}._domainkey.migadu.com.";
        ttl = 600;
      }
    ];

  googleSiteVerification = at: key: {
    at = "";
    ttl = 600;
    type = "TXT";
    value = [
      "google-site-verification=${key}"
    ];
  };
  # }}}
  # {{{ Discord domain verification
  discordVerification = at: key: [
    {
      at = if at == "" then "_discord" else "_discord.${at}";
      ttl = 600;
      type = "TXT";
      value = "dh=${key}";
    }
  ];
  # }}}
in
{
  satellite.dns.records = lib.flatten [
    (ghPage "doffycup")
    (ghPage "erratic-gate")
    (ghPage "giftstogo")
    (migaduMail "" "kfkhyexd")
    (migaduMail "orbit" "24s7lnum")
    (googleSiteVerification "" "PLDTV1yBxSRGgDU61yK7Ed8czHgJb3t5tIacK7vM-ks")
    # (picoSh "" "moonythm")
    (picoSh "backup" "moonythm")
    (discordVerification "" "e0707480c4e9713e0a15ca4e39d5fa3f5764fca4")
  ];
}
