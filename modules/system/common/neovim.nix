{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    corefonts
  ];

  environment.systemPackages = with pkgs; [
    fd
    lazygit
    ripgrep
    xclip
  ];

  system.activationScripts.nvimConfigPermissions.text = ''
    if [ -d /etc/nixos/nvim ]; then
      chown -R andrea:users /etc/nixos/nvim
      chmod -R u+rwX,go+rX /etc/nixos/nvim
      chmod u+w /etc/nixos/nvim
    fi
  '';
}
