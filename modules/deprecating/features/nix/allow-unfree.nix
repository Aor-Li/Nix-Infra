{ ... }:
let
  name = "feature/nix/allow-unfree";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;
    };

  flake.modules.homeManager.${name} =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
}
