{ ... }:
let
  name = "feature/sys/basic/hostname";
in
{
  flake.modules.nixos.${name} =
    { hostConfig, ... }:
    {
      networking.hostName = hostConfig.name;
    };
}
