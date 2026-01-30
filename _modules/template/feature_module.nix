{ self, lib, ... }:

let
  featurePath = [
    "myConfig"
    "features"
    "nvim"
  ];

  # ============================================================================
  # 1. 底层实现 (Implementations) - 保持不变，还是做逻辑路由
  # ============================================================================
  # 这里不需要改动，因为我们假设下面的 Public Part 已经把 options 注入进来了

  isBackend = cfg: name: (cfg.enable && cfg.backend == name);

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
        enable = lib.mkEnableOption "Neovim Meta-Feature (System)";
        backend = lib.mkOption {
          type = lib.types.enum [
            "nixvim"
            "nvf"
            "nixcat"
          ];
          default = "nixvim";
        };
      };

      config = lib.mkIf cfg.enable {
        # 这里的赋值现在是安全的，因为 options 已经被 Public Part 带进来了
        myConfig.features.nixvim.enable = isBackend cfg "nixvim";
        myConfig.features.nvf.enable = isBackend cfg "nvf";
        myConfig.features.nixcat.enable = isBackend cfg "nixcat";

        environment.variables.EDITOR = "nvim";
      };
    };

  hmImpl =
    { config, lib, ... }:
    let
      cfg = lib.getAttrFromPath featurePath config;
    in
    {
      options = lib.setAttrByPath featurePath {
        enable = lib.mkEnableOption "Neovim Meta-Feature (User)";
        backend = lib.mkOption {
          type = lib.types.enum [
            "nixvim"
            "nvf"
            "nixcat"
          ];
          default = "nixvim";
        };
      };

      config = lib.mkIf cfg.enable {
        myConfig.features.nixvim.enable = isBackend cfg "nixvim";
        myConfig.features.nvf.enable = isBackend cfg "nvf";
        myConfig.features.nixcat.enable = isBackend cfg "nixcat";
      };
    };

  # ============================================================================
  # 2. 公共部分 (Public Part) - 【关键修改点】
  # ============================================================================
  publicPart =
    {
      config,
      lib,
      self,
      ...
    }:
    {
      # 注意这里添加了 self

      options.myFlake.features.nvim = {
        enable = lib.mkEnableOption "Enable Neovim globally";
        backend = lib.mkOption {
          type = lib.types.enum [
            "nixvim"
            "nvf"
            "nixcat"
          ];
          default = "nixvim";
        };
      };

      config.flake = {
        # 2.2 导出 NixOS 模块 (Bundle)
        nixosModules.nvim =
          let
            flakeCfg = config.myFlake.features.nvim;
          in
          { ... }:
          {
            # 【核心修正】：在这里通过 self 引用兄弟模块
            # 这样用户只需要 import nvim，其他三个模块的 Option 定义就会自动加载
            imports = [
              nixosImpl
              self.nixosModules.nixvim
              self.nixosModules.nvf
              self.nixosModules.nixcat
            ];

            config = lib.mkIf flakeCfg.enable {
              myConfig.features.nvim.enable = lib.mkDefault true;
              myConfig.features.nvim.backend = lib.mkDefault flakeCfg.backend;
            };
          };

        # 2.3 导出 HM 模块 (Bundle)
        homeManagerModules.nvim =
          let
            flakeCfg = config.myFlake.features.nvim;
          in
          { ... }:
          {
            # 同理，HM 模块也需要携带所有的下级实现
            imports = [
              hmImpl
              self.homeManagerModules.nixvim
              self.homeManagerModules.nvf
              self.homeManagerModules.nixcat
            ];

            config = lib.mkIf flakeCfg.enable {
              myConfig.features.nvim.enable = lib.mkDefault true;
              myConfig.features.nvim.backend = lib.mkDefault flakeCfg.backend;
            };
          };
      };
    };

  # ============================================================================
  # 3. 内部策略
  # ============================================================================
  internalPart =
    { config, lib, ... }:
    {
      imports = [ publicPart ];
      config.myFlake.features.nvim.enable = lib.mkDefault true;
    };

in
{
  flake.flakeModules.nvim = publicPart;
  imports = [ internalPart ];
}
