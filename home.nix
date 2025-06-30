{ ... }:

{
  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers"  ];
  };

  home-manager.users.andrea = {pkgs, ...}: {
    programs.bash = {
      enable = true;
      bashrcExtra = ''
      export ANDROID_HOME=/home/andrea/Android/Sdk
      '';
    };
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    home.stateVersion = "24.11";

  };
  home-manager.backupFileExtension = "backup";
}
