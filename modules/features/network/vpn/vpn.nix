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
  flake = lib.setAttrByPath path {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = lib.getAttrFromPath path config;
      in
      {
        options = lib.setAttrByPath path {
          enable = lib.mkEnableOption "Whether to enable VPN configurations.";
          proxy = lib.mkOption {
            type = types.str;
            default = "";
          };
          no_proxy = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
        };

        config = lib.mkIf (cfg.enable && cfg.proxy != "") {
          environment.variables = {
            http_proxy = cfg.proxy;
            https_proxy = cfg.proxy;
            all_proxy = cfg.proxy;
            no_proxy = cfg.no_proxy;

            HTTP_PROXY = cfg.proxy;
            HTTPS_PROXY = cfg.proxy;
            ALL_PROXY = cfg.proxy;
            NO_PROXY = cfg.no_proxy;
          };
        };
      };
  };
}
