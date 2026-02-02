{ self, lib, ... }:
let
  namespace = "aor";

  # 模块结构路径 (用于 Export 结构 和 Option 子路径)
  # 这决定了:
  # 1. 外部引用路径: inputs.self.nixosModules.features.nvim
  # 2. 内部配置路径: config.aor.features.nvim
  featurePath = [
    "features"
    "nvim"
  ];

  # 绝对配置路径 (用于 mkOption 和 set config)
  # 结果: [ "aor" "features" "nvim" ]
  configPath = [ namespace ] ++ featurePath;

  # ============================================================================
  # 2. 模块实现区
  # ============================================================================

  nixosImpl =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = lib.getAttrFromPath configPath config;
    in
    {
      # Option 定义带 namespace
      options = lib.setAttrByPath configPath {
        enable = lib.mkEnableOption "Neovim Meta-Feature (System)";
      };

      config = lib.mkIf cfg.enable {
        environment = {
          systemPackages = [ pkgs.neovim ];
          variables.EDITOR = "nvim";
          shellAliases.vi = "nvim";
          shellAliases.vim = "nvim";
        };
      };
    };

  homeImpl =
    { config, lib, ... }:
    let
      cfg = lib.getAttrFromPath configPath config;
    in
    {
      # Option 定义带 namespace
      options = lib.setAttrByPath configPath {
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

      # Config 注入带 namespace
      config = lib.mkIf cfg.enable (
        lib.setAttrByPath configPath {
          ${cfg.backend}.enable = true;
        }
      );
    };

  # ============================================================================
  # 3. 公共接口区 (Public Interface)
  # ============================================================================

  publicPart =
    {
      config,
      lib,
      self,
      ...
    }:
    let
      # 从带 namespace 的路径获取配置
      flakeCfg = lib.getAttrFromPath configPath config;
    in
    {
      # Flake 层的 Option 依然需要 namespace
      options = lib.setAttrByPath configPath {
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
        # Export 1: NixOS 模块
        # 注意：这里我们使用 featurePath 而不是 configPath
        # 结果: flake.nixosModules.features.nvim
        nixosModules = lib.setAttrByPath featurePath (
          { ... }:
          {
            imports = [
              nixosImpl
              self.nixosModules.nixvim
              self.nixosModules.nvf
              self.nixosModules.nixcat
            ];
            # 注入配置时，依然需要指向带 namespace 的 configPath
            config = lib.setAttrByPath configPath {
              enable = lib.mkDefault flakeCfg.enable;
            };
          }
        );

        # Export 2: Home Manager 模块
        # 结果: flake.homeManagerModules.features.nvim
        homeManagerModules = lib.setAttrByPath featurePath (
          { ... }:
          {
            imports = [
              homeImpl
              self.homeManagerModules.nixvim
              self.homeManagerModules.nvf
              self.homeManagerModules.nixcat
            ];
            # 注入配置
            config = lib.setAttrByPath configPath {
              enable = lib.mkDefault flakeCfg.enable;
              backend = lib.mkDefault flakeCfg.backend;
            };
          }
        );
      };
    };

  # ============================================================================
  # 4. 内部默认配置
  # ============================================================================

  internalPart =
    { config, lib, ... }:
    {
      imports = [ publicPart ];
      config = lib.setAttrByPath configPath {
        enable = lib.mkDefault true;
      };
    };

in
{
  # 注意：这里我们只是把 publicPart 挂载到一个临时位置给 flake-parts 处理
  # 最终的导出是由 publicPart 内部的 config.flake 决定的
  flake.flakeModules.nvim = publicPart;
  imports = [ internalPart ];
}
