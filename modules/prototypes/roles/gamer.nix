{ config, ... }:
let
  flake.modules.homeManager."role/gamer" =
    { ... }:
    {
      imports = [ ];
    };
in
{
  inherit flake;
}
