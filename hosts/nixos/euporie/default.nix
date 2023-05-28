{
  imports = [
    ../common/global

    ../common/optional/pipewire.nix
    ../common/optional/touchpad.nix
    ../common/optional/lightdm.nix
    ../common/optional/xdg-portal.nix
    ../common/optional/hyprland.nix
  ];

  # Set the name of this machine!
  networking.hostName = "euporie";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
