{ lib, ... }:
let
  inherit (lib) types;

  hostType = types.submodule (
    { ... }:
    {
      options = {
        name = lib.mkOption {
          type = types.str;
          default = "";
          description = "Name of this host";
        };
        type = lib.mkOption {
          type = types.enum [
            "desktop"
            "laptop"
            "server"
            "vm"
            "wsl"
          ];
          default = "desktop";
          description = "Type of this host";
        };
        distro = lib.mkOption {
          type = types.enum [
            "nixos"
            "ubuntu"
            "arch"
            "darwin"
          ];
          default = "nixos";
          description = "OS distribution of this host";
        };
        system = lib.mkOption {
          type = types.enum [
            "x86_64-linux"
            "aarch64-linux"
          ];
          default = "x86_64-linux";
          description = "System architecture of this host";
        };
      };
      freeformType = types.attrsOf types.anything;
    }
  );

  userType = types.submodule (
    { ... }:
    {
      options = {
        options = {
          username = lib.mkOption {
            type = types.str;
            default = "";
            description = "Username of this user";
          };
          fullname = lib.mkOption {
            type = types.str;
            default = "";
            description = "Full name of this user";
          };
          email = lib.mkOption {
            type = types.str;
            default = "";
            description = "Email of this user";
          };
        };
        freeformType = types.attrsOf types.anything;
      };
    }
  );

in
{
  flake.aor.meta = {
    users = types.attrsOf userType;
    hosts = types.attrsOf hostType;
  };
}
