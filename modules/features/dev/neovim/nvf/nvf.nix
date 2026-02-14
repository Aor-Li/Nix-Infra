{ inputs, ... }:
{
  flake.aor.modules.feature.dev.neovim.nvf = {
    home =
      { config, lib, ... }:
      let
        cfg = config.aor.modules.feature.dev.neovim.nvf;
      in
      {
        imports = [
          inputs.nvf.homeManagerModules.default
        ];

        options.aor.modules.feature.dev.neovim.nvf = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = (config.aor.modules.feature.dev.neovim.impl == "nvf");
            description = "Use nvf as Neovim implementation";
          };
        };

        config = lib.mkIf cfg.enable {
          programs.nvf = {
            enable = true;
            enableManpages = true;
          };
        };
      };
  };
}
