{ ... }:
let
  name = "feature/gui/ghostty";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.ghostty.enable = true;
    };
}
