{ config, inputs, ... }:
let
  name = "feature/ai/opencode";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      ];

      xdg.configFile."opencode/opencode.jsonc".source =
        "${config.flake.meta.root}/modules/features/ai/opencode/opencode.jsonc";
    };
}
