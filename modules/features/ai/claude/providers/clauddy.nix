{ inputs, lib, ... }:
let
  name = "feature/ai/claude/clauddy";
in
{
  config.flake.modules.homeManager.${name} =
    { config, pkgs, lib, flakeConfig, ... }:
    let
      claude_config = flakeConfig."feature/ai/claude";
      clauddy_url = "https://claudecode.dpdns.org/api";
    in
    {
      sops = lib.mkIf (claude_config.provider == "clauddy") {
        secrets.anthropic_auth_token = {
          path = "%r/secrets/anthropic_auth_token.txt";
        };
        templates."%r/claude/settings.json" = {
          content = builtins.toJSON {
            env = {
              ANTHROPIC_BASE_URL = clauddy_url;
              ANTHROPIC_AUTH_TOKEN = config.sops.placeholder.anthropic_auth_token;
            };
          };
          path = "${config.home.homeDirectory}/.claude/settings.json";
        };
      };
    };
}
