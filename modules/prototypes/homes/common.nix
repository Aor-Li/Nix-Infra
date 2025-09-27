{ config, ... }:
let
  flake.modules.homeManager."home/common" =
    { options, lib, ... }:
    {
      imports = [
        config.flake.modules.homeManager."private/system"
        config.flake.modules.homeManager."private/nix"
        config.flake.modules.homeManager."feature/sys"
        config.flake.modules.homeManager."feature/nix"
        config.flake.modules.homeManager."feature/tui"
        config.flake.modules.homeManager."feature/gui"
        config.flake.modules.homeManager."feature/app"
      ];
    };
in
{
  inherit flake;
}
