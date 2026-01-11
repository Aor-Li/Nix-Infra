{ config, lib, ... }:
{
  options.flake.meta = {
    users = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "用户配置信息";
    };
    hosts = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "机器配置信息";
    };
    modules = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "每个flake-part模块的信息";
    };
    lib = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Shared library functions";
    };
  };
}
