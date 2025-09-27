{ ... }:
let
  name = "feature/sys/network/network-manager";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {

      networking.networkmanager.enable = true;
    };
}
