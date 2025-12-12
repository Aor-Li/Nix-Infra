{ config, ... }:
let
  flake.modules.homeManager."role/coder" =
    { ... }:
    {
      imports = [
      ];
    };
in
{
  inherit flake;
}
