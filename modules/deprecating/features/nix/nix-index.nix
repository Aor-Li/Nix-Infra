{ ... }:
let
  name = "feature/nix/nix-index";
in 
{
  flake.modules.nixos.${name} =
    { ... }:
    {
      programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
}
