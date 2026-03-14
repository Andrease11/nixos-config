{ ... }:

{
  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers"  ];
  };

  home-manager.users.andrea = { config, pkgs, ... }: {
    imports = [
      ./modules/home/neovim.nix
    ];

    programs.bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake path:/etc/nixos#nixos";
      };
      bashrcExtra = ''
      export ANDROID_HOME=/home/andrea/Android/Sdk

      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
      '';
    };
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    home.stateVersion = "24.11";

    home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";

  };
  home-manager.backupFileExtension = "backup";
}
