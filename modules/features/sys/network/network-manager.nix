{ ... }:
let
  name = "feature/system/network/network-manager";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {

      networking.networkmanager.enable = true;
    };
}
