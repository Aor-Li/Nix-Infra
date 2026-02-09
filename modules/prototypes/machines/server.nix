{ config, ... }:
{
  flake.aor.modules.nixos.machine.server = {
    imports = [
      config.flake.aor.modules.nixos.machine.common
    ];
  };
}
