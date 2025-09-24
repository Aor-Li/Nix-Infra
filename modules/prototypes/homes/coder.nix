{ config, ... }:
let
  flake.modules.homeManager."home/coder" =
    { ... }:
    {
      imports = [
        config.flake.modules.homeManager."feature/dev"
        config.flake.modules.homeManager."feature/tui"
        config.flake.modules.homeManager."feature/ai"
      ];
    };
in
{
  inherit flake;
}
