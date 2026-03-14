{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    corefonts
  ];

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
