{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    google-chrome
    git
    gh
    gcc
    vesktop
    lshw
    gnomeExtensions.astra-monitor
    gnomeExtensions.clipboard-indicator
    nix
    devenv
    claude-code
    nodejs
    pnpm
    android-studio
    python313
    uv
    unzip
    rustup
    lutris
    playwright
    playwright-test
    rpcs3
    heroic
    bluez
    exercism
  ];
}
