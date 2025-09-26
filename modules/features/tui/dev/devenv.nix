{ ... }:
let
  name = "feature/tui/dev/devenv";
in
{
  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.devenv
      ];
    };
}
