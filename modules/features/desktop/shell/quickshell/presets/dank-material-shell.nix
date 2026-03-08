{ inputs, lib, ... }:
let
  path = builtin.splitString "." "aor.modules.feature.desktop.shell.quickshell.presets.dank";
in
{
  flake = lib.setAttrByPath path {
    home =
      { ... }:
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
        ];

        programs.dank-material-shell.enable = true;
      };
  };
}
