{ ... }:

{
  imports = [
    ./base.nix
    ./desktop.nix
    ./audio.nix
    ./gpu-nvidia.nix
    ./gaming.nix
    ./packages.nix
    ./docker.nix
    ./neovim.nix
    ./direnv.nix
  ];
}
