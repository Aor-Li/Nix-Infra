{ config, lib, ... }:
{
  options.flake.meta = {

    users = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Users infos ( collected from modules/profiles/users)";
    };

    hosts = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Hosts infos ( collected from modules/profiles/hosts)";
    };

  };
}
