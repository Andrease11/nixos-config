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
    playwright
    playwright-test
    rpcs3
    heroic
    bluez
    exercism
  ];
}
