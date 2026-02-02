{ config, lib, ... }:
{
  options.flake.meta = {
    
    root = lib.mkOption {
      type = lib.types.string;
      default = "~/infra";
      description = "Root directory of the project.";
    };
    
    namespace = lib.mkOption {
      type = lib.types.string;
      default = "aor";
      description = "Root namespace of this flake";
    };
    
    users = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Users infos ( collected from modules/profiles/users)";
    };

    hosts = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Hosts infos ( collected from modules/profiles/hosts)";
    };

    lib = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Project library functions";
    };
  };
}
