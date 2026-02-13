{ config, inputs, ... }:
let
  name = "feature/ai/claude";
  subModules = [
    config.flake.modules.homeManager."${name}/hw"
    config.flake.modules.homeManager."${name}/clauddy"
  ];

  flake.meta.modules.${name} = {
    providers = {
      "Amanojaku" = "clauddy";
      "Bakotsu" = "hw";
      "Chimi" = "clauddy";
    };
  };
  flake.modules.homeManager.${name} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = subModules;

      options.modules.homeManager.${name}.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use claude code.";
      };

      config.home = lib.mkIf config.modules.homeManager.${name}.enable {
        packages = [
          inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        ];

        file.".claude/config.yaml".text = ''
          primaryApiKey: "crs"
        '';
      };
    };
in
{
  inherit flake;
}
