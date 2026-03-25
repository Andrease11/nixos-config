{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tea
    chromium
  ];
}
