{ lib, ... }:
{
  # 判断名称是否是直接上下级模块关系
  flake.meta.lib.isDirectSubmodule =
    module: sub:
    lib.hasPrefix "${module}/" sub && !(lib.hasInfix "/" (lib.strings.removePrefix "${module}/" sub));
}
