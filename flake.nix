{
  description = "NixOS system configuration";

  inputs = {
    # Pin exactly to the currently running NixOS nixpkgs revision.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }:
    let
      mkSystem = modules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          inherit modules;
        };
    in
    {
      nixosConfigurations = {
        personal-pc = mkSystem [
          ./hosts/personal-pc/default.nix
          home-manager.nixosModules.home-manager
        ];

        work-wsl = mkSystem [
          ./hosts/work-wsl/default.nix
          home-manager.nixosModules.home-manager
          nixos-wsl.nixosModules.default
        ];

        nixos = mkSystem [
          ./hosts/personal-pc/default.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
