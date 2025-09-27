{ inputs, ... }:
let
  name = "feature/nix/secret";
in
{
  flake.modules.homeManager.${name} =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      home.packages = [
        pkgs.age
        pkgs.sops
      ];
    };
}
