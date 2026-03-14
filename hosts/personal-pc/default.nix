{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common
    ../../modules/system/personal-pc
    ../../modules/home/profiles/personal-pc.nix
  ];

  system.stateVersion = "24.11";
}
