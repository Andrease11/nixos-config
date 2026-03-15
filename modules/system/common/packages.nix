{ pkgs, inputs, ... }:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config = pkgs.config;
  };
  csharpierNet9 = pkgs.writeShellScriptBin "csharpier-net9" ''
    export DOTNET_ROOT="/run/current-system/sw/share/dotnet"
    export DOTNET_MULTILEVEL_LOOKUP=0
    exec /run/current-system/sw/bin/csharpier "$@"
  '';
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
    dotnet-aspnetcore_8
    csharpier
    csharpierNet9
  ] ++ [
    pkgsUnstable.opencode
  ];
}
