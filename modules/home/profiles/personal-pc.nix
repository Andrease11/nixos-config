{ config, lib, ... }:

let
  githubSecretFile = ../../../secrets/personal-pc-github-hosts.yml.age;
  githubSecretExists = builtins.pathExists githubSecretFile;
in

{
  age.identityPaths = [ "/etc/agenix/personal-pc.agekey" ];

  age.secrets.personalGithubHosts = lib.mkIf githubSecretExists {
    file = githubSecretFile;
    owner = "andrea";
    group = "users";
    mode = "0400";
  };

  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers" ];
  };

  systemd.tmpfiles.rules = [
    "d /etc/agenix 0700 root root -"
  ];

  home-manager.users.andrea = { config, ... }: {
    imports = [ ../common ];

    programs.bash.shellAliases = {
      agenix-personal = "sudo EDITOR=nvim VISUAL=nvim agenix -i /etc/agenix/personal-pc.agekey";
    };

    xdg.configFile."gh/hosts.yml" = lib.mkIf githubSecretExists {
      source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/personalGithubHosts";
    };

    programs.bash.bashrcExtra = ''
      export ANDROID_HOME=/home/andrea/Android/Sdk

      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
    '';

    home.stateVersion = "24.11";
    home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";
  };

  home-manager.backupFileExtension = "backup";

  networking.hostName = "personal-pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  programs.firefox.enable = true;
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
}
