{ lib, ... }:
let
  inherit (lib) types;

  path = [
    "aor"
    "modules"
    "feature"
    "network"
    "vpn"
    "role"
    "inherit"
  ];
in
{
  flake = lib.setAttrsByPath path {
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
        options = lib.setAttrsByPath path {
          enable = lib.mkEnableOption "Inherit host network/VPN (for WSL/VM)";
          proxy = lib.mkOption {
            type = types.str;
            default = "";
            description = "Proxy URL to use inside WSL/VM";
          };
          no_proxy = lib.mkOption {
            type = types.listOf types.str;
            default = [];
            description = "List of domains to bypass proxy";
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
