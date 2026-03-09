{ inputs, lib, ... }:
let
  path = [
    "aor"
    "modules"
    "feature"
    "ai"
    "cli"
    "claude"
  ];
in
{
  flake = lib.setAttrByPath path {
    home =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = lib.getAttrFromPath path config;
        inherit (pkgs.stdenv.hostPlatform) system;
      in
      {
        options = lib.setAttrByPath path {
          enable = lib.mkEnableOption "";
          provider = lib.mkOption {
            type = lib.types.enum [
              "Clauddy"
              "Huawei"
            ];
            default = "Clauddy";
            description = "Claude provider.";
          };
        };

        config = lib.mkMerge [
          (lib.mkIf cfg.enable {
            home.packages = [
              inputs.nix-ai-tools.packages.${system}.claude-code
            ];
          })

          (lib.mkIf (cfg.enable && cfg.provider == "Clauddy") {
            sops = {
              secrets.clauddy_auth_token.path = "%r/secrets/clauddy_auth_token.txt";
              templates."%r/claude.settings.json" = {
                content = builtins.toJSON {
                  env = {
                    ANTHROPIC_BASE_URL = "https://claudecode.dpdns.org/api";
                    ANTHROPIC_AUTH_TOKEN = config.sops.placeholder.clauddy_auth_token;
                  };
                };
                path = "${config.home.homeDirectory}/.claude/settings.json";
              };
            };
          })

          (lib.mkIf (cfg.enable && cfg.provider == "Huawei") {
            # sops.secrets.huawei_claude_oauth_token = { };
          })
        ];

      };
  };
}
