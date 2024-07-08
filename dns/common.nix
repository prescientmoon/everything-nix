# DNS entries which do not belong to a particular host
{ lib, ... }:
let
  # {{{ Github pages helper
  ghPage = at: [{
    inherit at; type = "CNAME";
    value = "prescientmoon.github.io.";
  }];
  # }}}
  # {{{ Migadu mail DNS setup
  migaduMail = at: verifyKey:
    let atPrefix = prefix: if at == "" then prefix else "${prefix}.${at}";
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
        value = "key1.orbit.moonythm.dev._domainkey.migadu.com.";
        ttl = 600;
      }
      {
        at = atPrefix "key2._domainkey";
        type = "CNAME";
        value = "key2.orbit.moonythm.dev._domainkey.migadu.com.";
        ttl = 600;
      }
      {
        at = atPrefix "key3._domainkey";
        type = "CNAME";
        value = "key3.orbit.moonythm.dev._domainkey.migadu.com.";
        ttl = 600;
      }
    ];
  # }}}
in
{
  satellite.dns.domain = "moonythm.dev";
  satellite.dns.records = lib.flatten [
    (ghPage "doffycup")
    (ghPage "erratic-gate")
    (migaduMail "" "kfkhyexd")
    (migaduMail "orbit" "24s7lnum")
  ];
}
