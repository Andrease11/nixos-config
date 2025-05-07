{ config, pkgs, ... }:

{
  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  home-manager.users.andrea = {pkgs, ...}: {
    programs.bash.enable = true;

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    home.stateVersion = "24.11";

  };
  home-manager.backupFileExtension = "backup";
}
