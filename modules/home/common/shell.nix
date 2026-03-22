{ ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      nrs() {
        local host="''${1:-$(hostname)}"
        sudo nixos-rebuild switch --flake "path:/etc/nixos#''${host}"
      }
    '';
  };
}
