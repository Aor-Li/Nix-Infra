{ config, ... }:
{
  flake.aor.modules.nixos.machine.common = {
    imports = with config.flake.modules; [
      nixos."feature/sys"
      nixos."feature/nix"
      nixos."feature/tui"
      nixos."feature/gui"
      nixos."feature/app"
      nixos."feature/dev"
      nixos."feature/desktop"
    ];
  };
}
