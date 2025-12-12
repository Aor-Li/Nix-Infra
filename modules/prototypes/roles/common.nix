{ config, ... }:
let
  flake.modules.homeManager."role/common" =
    { options, lib, ... }:
    {
      imports = [
        config.flake.modules.homeManager."feature/sys"
        config.flake.modules.homeManager."feature/nix"

        config.flake.modules.homeManager."feature/tui"
        config.flake.modules.homeManager."feature/gui"
        config.flake.modules.homeManager."feature/app"
        config.flake.modules.homeManager."feature/dev"
      ];
    };
in
{
  inherit flake;
}
