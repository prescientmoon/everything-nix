{ ... }: {
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Bucharest";

  i18n.inputMethod = {
    enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [ /* any engine you want, for example */ anthy ];
  };

  console = {
    keyMap = "us";
    font = "SourceCodePro";
  };
}
