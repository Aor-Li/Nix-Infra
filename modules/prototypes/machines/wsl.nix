{ config, ... }:
{
  flake.aor.modules.nixos.machine.wsl = {
    imports = [
      config.flake.aor.modules.nixos.machine.common
    ];
  };
}
