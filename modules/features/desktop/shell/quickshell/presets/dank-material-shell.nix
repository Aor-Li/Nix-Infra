{ inputs, lib, ... }:
let
  path = lib.splitString "." "aor.modules.feature.desktop.shell.quickshell.presets.dank";
in
{
  flake = lib.setAttrByPath path {
    home =
      { ... }:
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
        ];

        programs.dank-material-shell = {
          enable = true;
          niri.enableSpawn = true; # Auto-start DMS with niri, if enabled
          systemd.enable = false;
        };
      };
  };
}
