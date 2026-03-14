# Edit this configuration file to define what should be installed on your system.

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system
    ./home.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  programs.firefox.enable = true;
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  system.stateVersion = "24.11";
}
