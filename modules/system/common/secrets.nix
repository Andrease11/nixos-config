{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.age
    inputs.agenix.packages.${pkgs.system}.default
  ];
}
