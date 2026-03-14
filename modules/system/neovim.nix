{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fd
    lazygit
    git
    gcc
    nodejs
    rustup
    ripgrep
    xclip
    fzf
  ];
}
