{ config, ... }:
{
  flake.aor.modules.nixos.machine.desktop = {
    imports = [
      config.flake.aor.modules.nixos.machine.common
    ];
  };
}
