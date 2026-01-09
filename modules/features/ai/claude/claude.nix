{ config, inputs, ... }:
let
  name = "feature/ai/claude";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    let
      source = "claude-hw"; # claude-hw or clauddy
    in
    {
      home.packages = [
        inputs.nix-ai-tools.packages.${pkgs.system}.claude-code
      ];

      imports = [
        config.flake.modules.homeManager."${name}/${source}"
      ];
    };
}
