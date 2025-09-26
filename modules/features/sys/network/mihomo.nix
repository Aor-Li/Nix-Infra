{ ... }:
let
  name = "feature/system/network/mihomo";
in
{
  flake.modules = {
    nixos.${name} =
      { pkgs, ... }:
      {
        # add clash-meta to the system packages
        environment.systemPackages = with pkgs; [
          clash-meta
        ];
      };
    homeManager.${name} = { ... }: { };
  };
}
