{ pkgs, ... }: {
  i18n.defaultLocale = "en_US.UTF-8";
  # time.timeZone = "Europe/Bucharest";
  time.timeZone = "Europe/Amsterdam";

  i18n.inputMethod = {
    enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [ /* any engine you want, for example */ anthy ];
  };

  environment.systemPackages = [
    pkgs.source-code-pro
  ];

  console = {
    keyMap = "us";
    font = "SourceCodePro";
  };
}
