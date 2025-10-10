{ ... }:
let
  name = "feature/sys/basic/boot";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
}
