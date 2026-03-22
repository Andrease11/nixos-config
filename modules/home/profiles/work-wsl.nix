{ config, lib, ... }:

let
  githubSecretFile = ../../../secrets/work-wsl-github-hosts.yml.age;
  githubSecretExists = builtins.pathExists githubSecretFile;
  teaSecretFile = ../../../secrets/work-wsl-tea-config.yml.age;
  teaSecretExists = builtins.pathExists teaSecretFile;
in

{
  age.identityPaths = [ "/etc/agenix/work-wsl.agekey" ];

  age.secrets.workGithubHosts = lib.mkIf githubSecretExists {
    file = githubSecretFile;
    owner = "andrea";
    group = "users";
    mode = "0400";
  };

  age.secrets.workTeaConfig = lib.mkIf teaSecretExists {
    file = teaSecretFile;
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

    programs.git = {
      enable = true;
      includes = [
        {
          condition = "gitdir:/etc/nixos/.git";
          path = "~/.config/git/config-github";
        }
      ];
      settings = {
        user.name = "Andrea Segalotti";
        user.email = "asegalotti@omegagruppo.it";
        safe.directory = "/etc/nixos";
        credential."https://git.omegagruppo.it".helper = "!tea login helper";
      };
    };

    programs.bash.shellAliases = {
      agenix-work = "sudo EDITOR=nvim VISUAL=nvim agenix -i /etc/agenix/work-wsl.agekey";
    };

    xdg.configFile."git/config-github".text = ''
      [user]
        name = Andrea Segalotti
        email = 249976131+asegalotti@users.noreply.github.com

      [credential "https://github.com"]
        helper = !/run/current-system/sw/bin/gh auth git-credential

      [credential "https://gist.github.com"]
        helper = !/run/current-system/sw/bin/gh auth git-credential
    '';

    xdg.configFile."gh/hosts.yml" = lib.mkIf githubSecretExists {
      source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/workGithubHosts";
    };

    xdg.configFile."tea/config.yml" = lib.mkIf teaSecretExists {
      source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/workTeaConfig";
    };

    home.stateVersion = "24.11";
    home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";
  };

  home-manager.backupFileExtension = "backup";

  programs.nix-ld.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.allowUnfree = true;
}
