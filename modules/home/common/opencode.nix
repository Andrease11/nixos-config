{ config, pkgs, inputs, ... }:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system config;
  };
  opencodeBinary = pkgs.lib.getExe pkgsUnstable.opencode;
  opencodeProfileDir = "${config.home.homeDirectory}/.config/opencode/profiles";
  workSqlMcpPasswordPath = "/run/agenix/workSqlMcpPassword";
  mkProfile =
    { playwright, dbhub }:
    builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      mcp = {
        playwright.enabled = playwright;
        dbhub.enabled = dbhub;
      };
    };
  profiles = {
    base = {
      playwright = false;
      dbhub = false;
    };
    frontend = {
      playwright = true;
      dbhub = false;
    };
    backend = {
      playwright = false;
      dbhub = true;
    };
  };
  dbhubBinary = pkgs.writeShellScriptBin "opencode-dbhub-mssql" ''
    if [ -r "${workSqlMcpPasswordPath}" ]; then
      export DB_PASSWORD="$(tr -d '\n' < "${workSqlMcpPasswordPath}")"
    fi

    exec ${pkgs.lib.getExe' pkgs.nodejs "npx"} -y @bytebase/dbhub@latest --transport stdio --config "${config.home.homeDirectory}/.config/opencode/dbhub.toml"
  '';
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
  home.packages = [
    dbhubBinary
    opencodeProfileLauncher
  ];

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

        dbhub = {
          type = "local";
          command = [
            "${pkgs.lib.getExe dbhubBinary}"
          ];
          enabled = false;
        };
      };
    };

    "opencode/dbhub.toml".text = ''
      [[sources]]
      id = "emerson"
      description = "SQL Server locale Emerson"
      type = "sqlserver"
      host = "OG-WKS0060-0326"
      port = 1433
      database = "EMERSON"
      user = "sa"
      password = "''${DB_PASSWORD}"
      sslmode = "require"
      query_timeout = 60

      [[tools]]
      name = "execute_sql"
      source = "emerson"
      readonly = true
      max_rows = 1000

      [[tools]]
      name = "search_objects"
      source = "emerson"
    '';

    "opencode/profiles/backend.json".text = mkProfile profiles.backend;
    "opencode/profiles/base.json".text = mkProfile profiles.base;
    "opencode/profiles/frontend.json".text = mkProfile profiles.frontend;
  };
}
