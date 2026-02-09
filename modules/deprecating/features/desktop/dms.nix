{ inputs, ... }:
let
  name = "feature/desktop/dms";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      # imports = [
        # inputs.dms.homeModules.dank-material-shell
        # inputs.dms.homeModules.niri
      # ];
# 
      # programs.dank-material-shell = {
        # enable = true;
        # niri = {
          # enableKeybinds = false;
          # enableSpawn = true;
        # };
      # };
    };
}
