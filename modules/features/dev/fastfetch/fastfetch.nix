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

        # link logo
        # [FIXME] 这里公司不支持上传图片，回家处理
        xdg.configFile."fastfetch/logo.jpg".source = config.lib.file.mkOutOfStoreSymlink (
          "${root}/modules/features/dev/fastfetch/logos/${hostConfig.name}.jpg"
        );
      };
  };
}
