{ inputs, ... }:
let
  name = "feature/tui/ai/claude-code";
in
{
  flake.modules.homeManager.${name} =
    { config, pkgs, ... }:
    let
      # config api
      clauddy_url = "https://claudecode.dpdns.org/api";
      hw_url = "http://api.anthropic.rnd.huawei.com";
      hw_token = "sk-1234";

      # config model
      model = "glm-4.5-air";
      small_model = "qwen3-coder-30b-a3b-instruct";
    in
    {
      # packages
      home.packages = [
        pkgs.nodejs_24
        inputs.nix-ai-tools.packages.${pkgs.system}.claude-code
      ];

      # secret key
      sops.secrets.anthropic_auth_token = {
        path = "%r/secrets/anthropic_auth_token.txt";
      };

      # configurations
      home.file.".claude/config.yaml".text = ''
        {
          "primaryApiKey": "crs"
        }
      '';

      # settings
      # NOTE: sops.templates replace placeholder at system activation time
      sops.templates."%r/claude/settings.json" = {
        content = builtins.toJSON {
          env = {
            ANTHROPIC_BASE_URL = clauddy_url;
            ANTHROPIC_AUTH_TOKEN = config.sops.placeholder.anthropic_auth_token;
          };
        };
        path = "${config.home.homeDirectory}/.claude/settings.json";
      };
      
      home.sessionVariables = {
        ANTHROPIC_BASE_URL = clauddy_url;
        ANTHROPIC_AUTH_TOKEN = config.sops.placeholder.anthropic_auth_token;
      };
    };
}
