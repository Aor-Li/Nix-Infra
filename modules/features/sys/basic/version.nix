{ ... }:
let
  name = "feature/sys/basic/version";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {
      system.stateVersion = "25.11";
    };
}
