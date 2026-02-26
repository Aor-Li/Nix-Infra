{ inputs, lib, ... }:
let
  path = [
    "aor"
    "modules"
    "feature"
    "ai"
    "cli"
    "claude"
  ];
in
{
  flake = lib.setAttrByPath path {
    home =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = lib.getAttrByPath path config;
        inherit (pkgs.stdenv.hostPlatform) system;
      in
      {
        options = lib.setAttrByPath path {
          enable = lib.mkEnableOption "";
          provider = lib.mkOption {
            type = lib.types.enum [
              "Clauddy"
              "Huawei"
            ];
            default = "Clauddy";
            description = "Claude provider.";
          };
        };

        config = lib.mkIf (cfg.enable) lib.mkMerge [
          {
            packages = [
              inputs.nix-ai-tools.packages.${system}.claude-code
            ];
          }
          ((lib.mkIf cfg.provider == "Clauddy") {
            # sops.secrets.clauddy_api_key = {
            #   mode = "0400";
            # };
          })
          ((lib.mkIf cfg.provider == "Huawei") {
            # sops.secrets.huawei_claude_oauth_token = { };
          })
        ];
      };
  };
}
