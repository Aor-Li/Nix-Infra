{ self, lib, ... }:

let
  # ============================================================================
  # 1. 底层实现 (Implementations)
  # ============================================================================
  # 这些是纯粹的 NixOS/HomeManager 模块逻辑。
  # 它们只关注：如果 enabled，我该配置什么系统选项。
  # 它们不关注：我是谁，我在哪台机器上。
  featurePath = [
    "myConfig"
    "features"
    "git"
  ];

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
      };
      config = lib.mkIf cfg.enable {
        programs.git.enable = true;
      };
    };

  # ============================================================================
  # 2. 公共部分 (Public Part) - Definition & Interface
  # ============================================================================
  # 这是一个标准的 flake-part module。
  # 职责：
  # 1. 定义 Flake 级别的 Option (统一控制入口)。
  # 2. 导出 nixosModules/homeManagerModules (带出厂设置的工厂模式)。
  publicPart =
    {
      config,
      options,
      lib,
      ...
    }:
    let
      # 获取 Flake 层面的配置值
      flakeCfg = config.myFlake.features.git;
    in
    {
      # 2.1 定义 Flake 级选项
      options.myFlake.features.git = {
        enable = lib.mkEnableOption "Git feature (controls both NixOS/HM)";
        defaultBranch = lib.mkOption {
          type = lib.types.str;
          default = "main";
        };
      };

      # 2.2 导出带默认值的 NixOS 模块 (Factory Injection)
      flake.nixosModules.git =
        { lib, ... }:
        {
          imports = [ nixosImpl ];
          config = lib.mkIf flakeCfg.enable {
            # 将 Flake Option 的值注入到底层实现中作为默认值
            myConfig.features.git.enable = lib.mkDefault true;
            myConfig.features.git.defaultBranch = lib.mkDefault flakeCfg.defaultBranch;
          };
        };

      # 2.3 导出带默认值的 HM 模块
      flake.homeManagerModules.git =
        { lib, ... }:
        {
          imports = [ hmImpl ];
          config = lib.mkIf flakeCfg.enable {
            myConfig.features.git.enable = lib.mkDefault true;
          };
        };
    };

  # ============================================================================
  # 3. 内部/私有部分 (Internal Part) - Wiring & Policy
  # ============================================================================
  # 职责：
  # 1. 继承 Public Part 的定义。
  # 2. 根据当前仓库的具体情况 (Policy)，自动设置 Flake Option。
  internalPart =
    { config, lib, ... }:
    {
      # 继承公共定义
      imports = [ publicPart ];

      # 自动化策略配置 (Policy)
      # 例如：在特定主机上自动开启 Flake Option
      # 注意：这里操作的是 options.myFlake...，而不是底层的 options.myConfig...
      config.myFlake.features.git.enable =
        lib.mkIf (config.flake.nixosConfigurations ? "work-laptop") # 仅作示例逻辑
          true;
    };

in
{
  # ============================================================================
  # 4. 注册与激活 (Registration & Activation)
  # ============================================================================

  # 4.1 对外注册 (Export to Consumers)
  # 外部用户通过 imports = [ inputs.myFlake.flakeModules.git ]; 使用
  # 他们得到的是纯净的接口，不包含你的 internalPart 策略
  flake.flakeModules.git = publicPart;

  # 4.2 对内注册 (Export to Self - Optional)
  # 如果你想显式保留一个包含自动化逻辑的引用路径
  flake.modules.parts.git = internalPart;

  # 4.3 立即激活 (Activate for Current Flake)
  # 这是让当前 flake 生效的关键。
  # 我们直接 import 局部变量 `internalPart`。
  # 由于 internalPart 已经 import 了 publicPart，所以整个链条都生效了。
  imports = [ internalPart ];
}
