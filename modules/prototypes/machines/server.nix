{ config, ... }:
{
  flake.aor.modules.prototype.machine.server = {
    imports = [
      config.flake.aor.modules.prototype.machine.common
    ];
  };
}
