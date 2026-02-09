{ config, inputs, lib, ... }:
let
  name = "feature/ai/claude/clauddy";
  moduleConfig = config.flake.meta.modules."feature/ai/claude";
in
{
  flake.modules.homeManager.${name} =
    { config, hostConfig, ... }:
    let
      clauddyUrl = "https://claudecode.dpdns.org/api";
    in
    {
      sops = lib.mkIf (moduleConfig.providers.${hostConfig.name} == "clauddy") {
        secrets.anthropic_auth_token = {
          path = "%r/secrets/anthropic_auth_token.txt";
        };
        templates."%r/claude/settings.json" = {
          content = builtins.toJSON {
            env = {
              ANTHROPIC_BASE_URL = clauddyUrl;
              ANTHROPIC_AUTH_TOKEN = config.sops.placeholder.anthropic_auth_token;
            };
          };
          path = "${config.home.homeDirectory}/.claude/settings.json";
        };
      };
    };
}
