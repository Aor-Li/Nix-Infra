{
  inputs,
  config,
  lib,
  ...
}:
let
  path = lib.splitString "." "aor.modules.feature.desktop.shell.quickshell.presets.dank";
  inherit (config.flake.aor.meta) root;
in
{
  flake = lib.setAttrByPath path {
    home =
      { config, ... }:
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
        ];

        programs.dank-material-shell = {
          enable = true;

          managePluginSettings = true;
          systemd.enable = false;
          niri.enableSpawn = true; # Auto-start DMS with niri, if enabled

          niri.includes = {
            enable = true;
            override = true;

            filesToInclude = [
              "alttab"
              "binds"
              "colors"
              "cursor"
              "layout"
              "outputs"
              "windowrules"
            ];
          };
        };

        # 将dms目录添加到$HOME/.config/niri下，从而能够被include
        # [TODO]: 创建一个GetFeaturePath函数来简化代码
        xdg.configFile."niri/dms".source = config.lib.file.mkOutOfStoreSymlink (
          "${root}/modules/features/desktop/shell/quickshell/presets/dank/dms"
        );
      };
  };
}
