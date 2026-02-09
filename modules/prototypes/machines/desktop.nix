{ config, lib, ... }:
{
  flake.aor.modules.prototype.machine.desktop = {
    imports = [
      config.flake.aor.modules.prototype.machine.common
    ];
  };
}
