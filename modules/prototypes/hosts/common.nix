{ config, ... }:
let
  flake.modules.nixos."host/common" =
    { ... }:
    {
      imports = [
        config.flake.modules.nixos."feature/sys"
        config.flake.modules.nixos."feature/nix"
        config.flake.modules.nixos."feature/tui"
        config.flake.modules.nixos."feature/gui"
        config.flake.modules.nixos."feature/app"
      ];
    };
in
{
  inherit flake;
}
