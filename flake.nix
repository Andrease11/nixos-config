{
  description = "NixOS system configuration";

  inputs = {
    # Current running NixOS revision from `nixos-version --json`.
    nixpkgs.url = "github:NixOS/nixpkgs/30e2e2857ba47844aa71991daa6ed1fc678bcbb7";

    # Keep Home Manager aligned with the current NixOS release family.
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
