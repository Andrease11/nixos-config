{ ... }:

{
  imports = [
    ../../modules/system/common
    ../../modules/system/work-wsl
    ../../modules/home/profiles/work-wsl.nix
  ];

  system.stateVersion = "24.11";
}
