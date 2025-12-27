{ inputs, ... }:
let
  name = "feature/tui/ai/spec-kit";
in 
{
  flake.modules.homeManager.${name} = 
    { ... }:
    {
      home.packages = [
        inputs.nix-ai-tools.packages.${pkgs.system}.spec-kit
      ];

    };
}
