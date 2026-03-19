{ ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    historyLimit = 100000;
    baseIndex = 1;
    escapeTime = 0;
  };
}
