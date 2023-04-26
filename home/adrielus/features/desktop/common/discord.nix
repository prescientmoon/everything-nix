{
  programs.discord = {
    enable = true;
    disableUpdateCheck = true;
    enableDevtools = true;
  };

  home.persistence."/persist/home/adrielus".directories = [
    ".config/discord" # Why tf does discord store it's state here 💀
  ];
}
