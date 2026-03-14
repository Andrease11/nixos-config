{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "it";
      variant = "";
    };
  };

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
  };

  console.keyMap = "it2";
}
