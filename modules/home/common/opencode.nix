{ ... }:

{
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    mcp = {
      playwright = {
        type = "local";
        command = [
          "npx"
          "-y"
          "@playwright/mcp@latest"
          "--headless"
          "--executable-path"
          "/run/current-system/sw/bin/chromium"
        ];
        enabled = true;
      };
    };
  };
}
