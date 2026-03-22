{ config, lib, ... }:

let
  githubSecretFile = ../../../secrets/work-wsl-github-hosts.yml.age;
  githubSecretExists = builtins.pathExists githubSecretFile;
in

{
  age.identityPaths = [ "/etc/agenix/work-wsl.agekey" ];

  age.secrets.workGithubHosts = lib.mkIf githubSecretExists {
    file = githubSecretFile;
    owner = "andrea";
    group = "users";
    mode = "0400";
  };

  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
    extraGroups = [ "wheel" ];
  };

  systemd.tmpfiles.rules = [
    "d /etc/agenix 0700 root root -"
  ];

  home-manager.users.andrea = { config, ... }: {
    imports = [ ../common ];

    programs.bash.shellAliases = {
      agenix-work = "agenix -i ~/.config/agenix/work-wsl.agekey";
    };

    xdg.configFile."gh/hosts.yml" = lib.mkIf githubSecretExists {
      source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/workGithubHosts";
    };

    home.stateVersion = "24.11";
    home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";
  };

  home-manager.backupFileExtension = "backup";

  programs.nix-ld.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.allowUnfree = true;
}
