{ config, lib, ... }:
let
  name = "feature/ai/claude/hw";
  moduleConfig = config.flake.meta.modules."feature/ai/claude";
in
{
  flake.modules.homeManager.${name} =
    { lib, hostConfig, ... }:
    let
      ANTHROPIC_AUTH_TOKEN = "sk-1234";
      ANTHROPIC_API_KEY = "";
      ANTHROPIC_BASE_URL = "http://api.antropic/rnd.huawei.com";
    in
    {
      home = lib.mkIf (moduleConfig.providers.${hostConfig.name} == "hw") {
        sessionVariables = {
          inherit ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY ANTHROPIC_BASE_URL;
        };
      };
    };
}
