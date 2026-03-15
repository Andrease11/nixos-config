{ pkgs, inputs, ... }:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config = pkgs.config;
  };
in
{
  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    gcc
    nix
    devenv
    claude-code
    nodejs
    pnpm
    python313
    uv
    unzip
    rustup
    dotnet-runtime_9
    csharpier
  ] ++ [
    pkgsUnstable.opencode
  ];
}
