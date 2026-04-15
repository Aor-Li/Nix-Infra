{ config, ... }:
let
  inherit (config.flake.aor.meta) root;
in
{
  flake.aor.modules.feature.dev.fastfetch = {
    home =
      { config, hostConfig, ... }:
      {
        programs.fastfetch.enable = true;

        home.shellAliases = {
          ff = "fastfetch";
        };

        # link config
        xdg.configFile."fastfetch/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink (
          "${root}/modules/features/dev/fastfetch/config.jsonc"
        );
      };
  };
}
