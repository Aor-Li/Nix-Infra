{ ... }:
let
  name = "feature/dev/env/direnv";
in
{
  flake.modules.homeManager.${name} =
    { ... }:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
