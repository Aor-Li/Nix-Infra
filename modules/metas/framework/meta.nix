{ config, lib, ... }:
{
  options.flake.meta = {
    
    # root dir 
    root = "~/infra";
    
    # root option name
    name = "aor";
    
    # all users infos 
    users = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "用户配置信息";
    };

    # all hosts infos
    hosts = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "机器配置信息";
    };

    # lib used in this project
    lib = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Shared library functions";
    };
  };
}
