{ inputs, ... }:
let
  name = "feature/tui/ai/codex";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.nix-ai-tools.packages.${pkgs.system}.codex
      ];
    };
}
