{ lib, ... }:
let
  name = "feature/ai/claude/hw";
in
{
  config.flake.modules.homeManager.${name} =
    { config, lib, flakeConfig, ... }:
    let
      claude_config = flakeConfig."feature/ai/claude";

      ANTHROPIC_AUTH_TOKEN = "sk-1234";
      ANTHROPIC_API_KEY = "";
      ANTHROPIC_BASE_URL = "http://api.antropic/rnd.huawei.com";
    in
    {
      home = lib.mkIf (claude_config.provider == "hw") {
        sessionVariables = {
          inherit ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY ANTHROPIC_BASE_URL;
        };
      };
    };
}
