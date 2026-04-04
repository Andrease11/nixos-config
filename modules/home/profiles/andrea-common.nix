_:

{
  users.users.andrea = {
    isNormalUser = true;
    description = "Andrea Segalotti";
  };

  systemd.tmpfiles.rules = [
    "d /etc/agenix 0700 root root -"
  ];

  home-manager.users.andrea =
    { config, ... }:
    {
      imports = [ ../common ];

      home.stateVersion = "24.11";
      home.file."nixos".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";
    };

  home-manager.backupFileExtension = "backup";

  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
}
