_:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nfu = "nix flake update --flake /etc/nixos";
    };
    bashrcExtra = ''
      nrs() {
        local host="''${1:-$(hostname)}"
        sudo nixos-rebuild switch --flake "path:/etc/nixos#''${host}"
      }
    '';
  };
}
