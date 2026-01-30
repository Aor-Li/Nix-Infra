{ self, lib, ... }:

let
  featurePath = [
    "myConfig"
    "features"
    "git"
  ];

  # ============================================================================
  # 1. 纯粹的实现逻辑 (Implementations)
  # ============================================================================
  # 它们完全不知道 Flake 的存在，只通过 myConfig 交互。
  # 它们定义了自己的 options，不依赖外部。

  nixosImpl =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = lib.getAttrFromPath featurePath config;
    in
    {
      options = lib.setAttrByPath featurePath {
        enable = lib.mkEnableOption "Git system implementation";
        defaultBranch = lib.mkOption {
          type = lib.types.str;
          default = "main";
        };
      };
      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.git ];
        programs.git.config.init.defaultBranch = cfg.defaultBranch;
      };
    };

  hmImpl =
    { config, lib, ... }:
    let
      cfg = lib.getAttrFromPath featurePath config;
    in
    {
      options = lib.setAttrByPath featurePath {
        enable = lib.mkEnableOption "Git user implementation";
        # Home Manager 可以有自己独立的配置项，也可以复用结构
      };
      config = lib.mkIf cfg.enable {
        programs.git.enable = true;
      };
    };

  # ============================================================================
  # 2. 公共部分 (Public Part) - 负责转换和导出
  # ============================================================================
  publicPart =
    { config, lib, ... }:
    {
      # 2.1 定义 Flake 级选项 (控制总开关)
      options.myFlake.features.git = {
        enable = lib.mkEnableOption "Git global trigger";
        defaultBranch = lib.mkOption {
          type = lib.types.str;
          default = "main";
        };
      };

      config.flake = {
        # 【关键点】导出时，我们捕捉当前的 flakeCfg 值并注入
        # 这利用了 Nix 的闭包特性：flakeCfg 在这里被求值并“锁”进了下面的函数中

        nixosModules.git =
          let
            # 在这里“固化” Flake 层的配置
            flakeCfg = config.myFlake.features.git;
          in
          { ... }:
          {
            imports = [ nixosImpl ];
            # 注入逻辑：将 Flake 的值作为 module 的默认值传入
            # 这样 NixOS 模块内部不需要访问 Flake config，它只看到 options 被设置了
            config = lib.mkIf flakeCfg.enable {
              myConfig.features.git.enable = lib.mkDefault true;
              myConfig.features.git.defaultBranch = lib.mkDefault flakeCfg.defaultBranch;
            };
          };

        homeManagerModules.git =
          let
            flakeCfg = config.myFlake.features.git;
          in
          { ... }:
          {
            imports = [ hmImpl ];
            # 同样的逻辑注入到 HM，HM 甚至不知道 NixOS 的存在
            config = lib.mkIf flakeCfg.enable {
              myConfig.features.git.enable = lib.mkDefault true;
            };
          };
      };
    };

  # ============================================================================
  # 3. 内部策略 (Internal Part)
  # ============================================================================
  internalPart =
    { config, lib, ... }:
    {
      imports = [ publicPart ];

      # 这里的逻辑仅影响当前 Flake，它操作的是 myFlake 的 Option
      # 只有当 internalPart 被 import 时（即在当前 flake 中），这行才生效
      config.myFlake.features.git.enable = lib.mkDefault true;
    };

in
{
  flake.flakeModules.git = publicPart;
  imports = [ internalPart ];
}
