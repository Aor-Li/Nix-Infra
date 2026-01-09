{ ... }:
let
  name = "feature/tui/dev/direnv";
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
