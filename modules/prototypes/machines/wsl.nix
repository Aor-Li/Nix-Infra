{ config, ... }:
{
  flake.aor.modules.prototype.machine.wsl = {
    imports = [
      config.flake.aor.modules.prototype.machine.common
    ];
  };
}
