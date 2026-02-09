{ lib, ... }:
{
  options.flake.aor = {

    meta = {
      users = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Users infos ( Defined in modules/profiles/users)";
      };

      hosts = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Hosts infos ( Defined in modules/profiles/hosts)";
      };
    };

    lib = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Project library functions";
    };

    modules = {

      home = lib.mkOption {
        description = "A tree of Home Manager modules.";
        default = { };
        type = lib.types.anything;
      };

      nixos = lib.mkOption {
        description = "A tree of NixOS modules.";
        default = { };
        type = lib.types.anything;
      };

      darwin = lib.mkOption {
        description = "A tree of Darwin modules.";
        default = { };
        type = lib.types.anything;
      };

    };
  };
}
