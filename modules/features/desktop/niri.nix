{ inputs, ... }:
let
  name = "feature/desktop/niri";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.homeModules.niri ];

      programs.niri.enable = true;
    };
}
