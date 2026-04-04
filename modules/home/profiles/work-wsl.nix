{ lib, ... }:

let
  githubSecretFile = ../../../secrets/work-wsl-github-hosts.yml.age;
  teaSecretFile = ../../../secrets/work-wsl-tea-config.yml.age;
  mkOptionalAgeSecret =
    file:
    lib.mkIf (builtins.pathExists file) {
      inherit file;
      owner = "andrea";
      group = "users";
      mode = "0400";
    };
in

{
  imports = [ ./andrea-common.nix ];

  age = {
    identityPaths = [ "/etc/agenix/work-wsl.agekey" ];
    secrets.workGithubHosts = mkOptionalAgeSecret githubSecretFile;
    secrets.workTeaConfig = mkOptionalAgeSecret teaSecretFile;
  };

  users.users.andrea = {
    extraGroups = [ "docker" ];
  };

  home-manager.users.andrea =
    { config, ... }:
    {
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

      xdg.configFile = {
        "git/config-github".text = ''
          [user]
            name = Andrea Segalotti
            email = 249976131+asegalotti@users.noreply.github.com

          [credential "https://github.com"]
            helper = !/run/current-system/sw/bin/gh auth git-credential

          [credential "https://gist.github.com"]
            helper = !/run/current-system/sw/bin/gh auth git-credential
        '';

        "gh/hosts.yml" = lib.mkIf (builtins.pathExists githubSecretFile) {
          source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/workGithubHosts";
        };

        "tea/config.yml" = lib.mkIf (builtins.pathExists teaSecretFile) {
          source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/workTeaConfig";
        };
      };
    };
}
