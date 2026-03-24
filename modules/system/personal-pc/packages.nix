{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-chrome
    vesktop
    lshw
    gnomeExtensions.astra-monitor
    gnomeExtensions.clipboard-indicator
    android-studio
    lutris
    rpcs3
    heroic
    bluez
    exercism
  ];
}
