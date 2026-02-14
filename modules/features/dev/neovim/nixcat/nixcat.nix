{ inputs, ... }:
{
  flake.aor.modules.feature.dev.neovim.nixcat = {
    home =
      { config, lib, ... }:
      let
        cfg = config.aor.modules.feature.dev.neovim.nixcat;
      in
      {
        options.aor.modules.feature.dev.neovim.nixcat = {
          enable = lib.mkEnableOption "";
        };

        config = lib.mkIf cfg.enable {
          programs.nixcat.enable = true;
        };
      };
  };
}
