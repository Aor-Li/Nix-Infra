{ ... }:
{
  flake.aor.modules.feature.dev.neovim.lazyvim = {
    home = {
      config, lib, ...
    }:
    let
      cfg = config.aor.modules.feature.dev.neovim.lazyvim;
    in
    {
      options.aor.modules.feature.dev.neovim.lazyvim = {
        enable = lib.mkEnableOption "";
      };

      config = lib.mkIf cfg.enable {
        
      };
    };
  };
}