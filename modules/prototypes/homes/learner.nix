{ config, ... }:
let
  flake.modules.homeManager."home/learner" =
    { options, lib, ... }:
    {
      imports = [
      ];
    };
in
{
  inherit flake;
}
