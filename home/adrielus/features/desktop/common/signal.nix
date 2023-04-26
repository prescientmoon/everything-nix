{ pkgs, ... }: {
  home.packages = [
    pkgs.signal-desktop # Signal client
  ];

  home.persistence."/persist/home/adrielus".directories = [
    ".config/Signal" # Why tf does signal store it's state here 💀
  ];
}
