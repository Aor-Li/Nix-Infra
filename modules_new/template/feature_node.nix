# 功能节点模块模板
# 用途: 定义单个功能，同时作为系统组件和可导出模块
#
# 使用方法:
#   1. 复制此模板到 modules/ 下的适当位置
#   2. 修改 name 和 exportName
#   3. 在 imports 中添加依赖的子功能模块
#   4. 实现所需的 module 类型（可删除不需要的）
{ config, lib, inputs, ... }:
let
  # ============ 命名配置 ============
  # 内部路径名 - 用于系统内部引用，保持层次结构
  # 格式: feature/{category}/{name} 或 {type}/{name}
  name = "feature/category/example";

  # 导出短名 - 用于外部使用，简洁易记
  exportName = "example";

  # ============ 辅助函数 ============
  # 可在此定义模块间共享的工具函数
  cfg = config.flake.modules;

in
{
  # ============ 依赖声明 ============
  # 通过 imports 引入此功能依赖的子功能模块
  imports = [
    # ./subfolder/subfeature.nix
  ];

  # ============ flake-parts module 导出 ============
  # 供外部 flake 组合使用，使用短名导出
  flake.modules.parts.${exportName} = { ... }: {
    # 外部使用时的 flake-parts 配置
    # 通常用于重新导出整个功能树
  };

  # ============ NixOS module 导出 ============
  # 系统层配置，使用完整路径名
  flake.modules.nixos.${name} =
    { config, lib, pkgs, hostConfig ? { }, flakeConfig ? { }, ... }:
    let
      # 模块内部配置变量
      # cfg = config.programs.example;
    in
    {
      # 可选: 定义 options
      # options.programs.example = { ... };

      # 系统配置实现
      config = {
        # environment.systemPackages = [ ... ];
      };
    };

  # ============ Home Manager module 导出 ============
  # 用户层配置，使用完整路径名
  flake.modules.homeManager.${name} =
    { config, lib, pkgs, userConfig ? { }, instanceConfig ? { }, ... }:
    let
      # 模块内部配置变量
      # cfg = config.programs.example;
    in
    {
      # 可选: 定义 options
      # options.programs.example = { ... };

      # 用户配置实现
      config = {
        # home.packages = [ ... ];
      };
    };

  # ============ nix-darwin module 导出 ============
  # macOS 系统层配置，使用完整路径名
  flake.modules.darwin.${name} =
    { config, lib, pkgs, hostConfig ? { }, flakeConfig ? { }, ... }:
    {
      # macOS 特定的系统配置
      config = {
        # homebrew.casks = [ ... ];
      };
    };
}
