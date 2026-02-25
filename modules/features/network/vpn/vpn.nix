{ lib, ... }:
let
  inherit (lib) types;

  path = [
    "aor"
    "modules"
    "feature"
    "network"
    "vpn"
  ];
in
{
  flake = lib.setAttrsByPath path {
    nixos =
      {
        config,
        lib,
        hostConfig,
        ...
      }:
      {
        # 根据host类型分配vpn方案：
        #   desktop:
        #
        config = lib.mkMerge [
          ((lib.mkIf hostConfig == "desktop") { })
          ((lib.mkIf hostConfig == "desktop") { })
          ((lib.mkIf hostConfig == "desktop") { })
          ((lib.mkIf hostConfig == "desktop") { })
          ((lib.mkIf hostConfig == "desktop") { })
          ((lib.mkIf hostConfig == "desktop") { })
        ];
      };
  };
}
