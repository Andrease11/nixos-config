{ lib, ... }:

let
  githubSecretFile = ../../../secrets/personal-pc-github-hosts.yml.age;
  githubSecretExists = builtins.pathExists githubSecretFile;
in

{
  imports = [ ./andrea-common.nix ];

  age.identityPaths = [ "/etc/agenix/personal-pc.agekey" ];

  age.secrets.personalGithubHosts = lib.mkIf githubSecretExists {
    file = githubSecretFile;
    owner = "andrea";
    group = "users";
    mode = "0400";
  };

  users.users.andrea = {
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "adbusers"
    ];
  };

  home-manager.users.andrea =
    { config, ... }:
    {
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
    };

  networking.hostName = "personal-pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  programs.firefox.enable = true;
}
