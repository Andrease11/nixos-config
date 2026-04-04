{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  services = {
    flatpak.enable = true;

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "it";
        variant = "";
      };
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.mutter ];
    };
  };

  console.keyMap = "it2";
}
