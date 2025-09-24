{ ... }:
let
  name = "feature/dev/devenv";
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
