{ ... }:

{
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    mcp = {
      playwright = {
        type = "local";
        command = [ "npx" "-y" "@playwright/mcp@latest" ];
        enabled = true;
      };
    };
  };
}
