{ config, pkgs, ... }:

let
  opencodeBinary = "/run/current-system/sw/bin/opencode";
  opencodeProfileDir = "${config.home.homeDirectory}/.config/opencode/profiles";
  mkProfile =
    { playwright, mssql_reader }:
    builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      mcp = {
        playwright.enabled = playwright;
        mssql_reader.enabled = mssql_reader;
      };
    };
  profiles = {
    base = {
      playwright = false;
      mssql_reader = false;
    };
    frontend = {
      playwright = true;
      mssql_reader = false;
    };
    backend = {
      playwright = false;
      mssql_reader = true;
    };
  };
  opencodeProfileLauncher = pkgs.writeShellScriptBin "opencode-profile" ''
    profile=""

    if [ "$1" = "--profile" ]; then
      profile="$2"
      shift 2
    fi

    if [ -z "$profile" ]; then
      printf 'Select OpenCode profile:\n'
      printf '  1) base\n'
      printf '  2) frontend\n'
      printf '  3) backend\n'
      printf '> '
      read -r profile
    fi

    case "$profile" in
      1|base)
        config_file="${opencodeProfileDir}/base.json"
        ;;
      2|frontend)
        config_file="${opencodeProfileDir}/frontend.json"
        ;;
      3|backend)
        config_file="${opencodeProfileDir}/backend.json"
        ;;
      *)
        printf 'Unknown OpenCode profile: %s\n' "$profile" >&2
        exit 1
        ;;
    esac

    export OPENCODE_CONFIG="$config_file"
    exec "${opencodeBinary}" "$@"
  '';
in

{
  home.packages = [ opencodeProfileLauncher ];

  programs.bash.shellAliases = {
    opencode = "opencode-profile";
    ocp = "opencode-profile";
    ocr = opencodeBinary;
  };

  xdg.configFile = {
    "opencode/opencode.json".text = builtins.toJSON {
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
          enabled = false;
        };

        mssql_reader = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@connorbritain/mssql-mcp-reader@latest"
          ];
          environment = {
            ENVIRONMENTS_CONFIG_PATH = "${config.home.homeDirectory}/.config/opencode/mssql-environments.json";
          };
          enabled = false;
        };
      };
    };

    "opencode/mssql-environments.json".text = builtins.toJSON {
      defaultEnvironment = "emerson";
      secrets = {
        providers = [
          {
            type = "env";
          }
        ];
      };
      environments = [
        {
          name = "emerson";
          server = "NBASEGALOTTI";
          database = "EMERSON";
          authMode = "sql";
          username = "sa";
          password = "\${secret:SQL_SA_PASSWORD}";
          trustServerCertificate = true;
          readonly = true;
          description = "SQL Server locale Emerson";
        }
      ];
    };

    "opencode/profiles/backend.json".text = mkProfile profiles.backend;
    "opencode/profiles/base.json".text = mkProfile profiles.base;
    "opencode/profiles/frontend.json".text = mkProfile profiles.frontend;
  };
}
