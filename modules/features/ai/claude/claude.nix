{ config, inputs, lib, ... }:
let
  name = "feature/ai/claude";
  providers = {
    "Amanojaku" = "clauddy";
    "Bakotsu" = "hw";
    "Chimi" = "clauddy";
  };
in
{
  options.flake.moduleOptions.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable the claude-code function.";
    };
    provider = lib.mkOption {
      type = lib.types.enum [ "clauddy" "hw" "none" ];
      default = "none";
      description = "Select which claude provider to use";
    };
  };

  config.flake.modules.homeManager.${name} =
    { config, pkgs, lib, hostConfig, userConfig, flakeConfig, ... }:
    let
      moduleConfig = flakeConfig.${name};
      provider = providers.${hostConfig.name} or "none";
    in
    {
      home = lib.mkIf moduleConfig.enable {
        packages = [
          inputs.nix-ai-tools.packages.${pkgs.system}.claude-code
        ];

        file.".claude/config.yaml".text = ''
          {
            "primaryApiKey": "crs"
          }
        '';
      };
    };
}
