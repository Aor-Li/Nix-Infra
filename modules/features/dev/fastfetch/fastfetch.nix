{ config, ... }:
let
  inherit (config.flake.aor.meta) root;
in
{
  flake.aor.modules.feature.dev.fastfetch = {
    home =
      { config, ... }:
      {
        programs.fastfetch.enable = true;
        xdg.configFile."fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink (
          "${root}/modules/features/dev/fastfetch/config.jsonc"
        );
      };

    _meta = {
      inherit root;
    };
  };
}
