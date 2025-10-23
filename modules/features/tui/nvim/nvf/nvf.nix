{ inputs, ... }:
let
  name = "feature/tui/nvim/nvf";
in
{
  flake.modules.homeManager.${name} =
    {
      config,
      options,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nvf.homeManagerModules.default
      ];

      options.meta.${name} = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable NVF support";
        };

        profile = lib.mkOption {
          type = lib.types.enum [
            "minimal"
            "full"
          ];
          default = "full";
          description = "NVF profile to use.";
        };
      };

      config = lib.mkIf config.${name}.enable {
        programs.nvf = {
          enable = true;
          enableManpages = true;
        };
      };
    };
}
