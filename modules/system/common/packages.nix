{ pkgs, ... }:

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
    opencode
  ];
}
