{ ... }:
let
  name = "feature/tui/yazi";
in
{
  flake.modules = {
    homeManager.${name} =
      { ... }:
      {
        programs.yazi.enable = true;
      };
  };
}
