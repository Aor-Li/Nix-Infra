{ ... }:
let
  name = "feature/desktop/sway";
in
{
  flake.modules.homeManager.${name} = 
    { pkgs, ... }: 
    {
      programs.niri.enable = true;
    };
}
