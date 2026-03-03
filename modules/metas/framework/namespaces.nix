{ lib, ... }:
{
  options.flake.aor = {

    meta = {
      root = lib.mkOption {
        type = lib.types.str;
        default = "/home/aor/infra";
        description = "Root path of the project ( Used for relative paths in modules and features)";
      };

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

    devShells = lib.mkOption {
      description = "Development shell environments (functions from pkgs to derivation)";
      default = { };
      type = lib.types.attrsOf lib.types.raw;
    };

    modules = {

      prototype = {
        machine = lib.mkOption {
          description = "A tree of machine prototypes.";
          default = { };
          type = lib.types.attrsOf lib.types.deferredModule;
        };

        role = lib.mkOption {
          description = "A tree of role prototypes.";
          default = { };
          type = lib.types.attrsOf lib.types.deferredModule;
        };
      };

      profile = {
        host = lib.mkOption {
          description = "A tree of host profiles.";
          default = { };
          type = lib.types.attrsOf lib.types.deferredModule;
        };

        user = lib.mkOption {
          description = "A tree of user profiles.";
          default = { };
          type = lib.types.attrsOf lib.types.deferredModule;
        };
      };
    };
  };
}
