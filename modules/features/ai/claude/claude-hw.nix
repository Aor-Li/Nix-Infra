{ ... }:
let
  name = "feature/ai/claude/claude-hw";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    let
      ANTHROPIC_AUTH_TOKEN = "sk-1234";
      ANTHROPIC_API_KEY = "";
      ANTHROPIC_BASE_URL = "http://api.antropic/rnd.huawei.com";
    in
    {
      home.sessionVariable = {
        inherit ANTHROPIC_AUTH_TOKEN ANTHROPIC_API_KEY ANTHROPIC_BASE_URL;
      };
    };
}
