# Nix Infra Monorepo 设计规范

## 设计目标

构建一个多用户、多机器的 NixOS 基础设施配置系统，实现：

- **功能复用**：通过模块化设计，在不同机器和用户间共享配置
- **关注点分离**：将功能逻辑与具体部署解耦
- **自动化组织**：减少手动导入和配置连接的样板代码

---

## 1. 核心架构

### 1.1 Dendritic Pattern

本项目采用 [Dendritic Pattern](https://github.com/mightyiam/dendritic)，核心原则：

> **每个 Nix 文件都是顶层配置的模块，按功能而非配置类型组织。**

这意味着：

- `modules/` 下所有 `.nix` 文件（除 `_` 开头者）自动作为 flake-parts 模块导入
- 文件路径代表功能，可自由重命名和移动
- 单个文件可同时定义 nixos、home-manager 等多种模块

**自动导入机制**：
```nix
# flake.nix
inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
```

### 1.2 Flake-Parts 扩展

基于 flake-parts 框架，扩展以下核心 options：

| Option | 用途 |
|--------|------|
| `flake.meta` | 元信息：namespace、机器列表、用户列表、全局 lib |
| `flake.modules.parts` | 功能模块的配置数据存储 |
| `flake.modules.nixos` | 内部 NixOS 模块存储 |
| `flake.modules.homeManager` | 内部 Home-Manager 模块存储 |

**与标准 flake 输出的区别**：
- `flake.modules.*`：内部使用的模块（带有 hostConfig/userConfig 上下文）
- `flake.nixosModules.*`：对外导出的纯净模块（无环境假设）

---

## 2. 三层模块体系

```
┌─────────────────────────────────────────────────────┐
│  profiles/     具体配置层（真实部署）               │
│  ├── hosts/    机器配置 → nixosConfigurations      │
│  └── users/    用户配置 → homeConfigurations       │
├─────────────────────────────────────────────────────┤
│  prototypes/   原型模板层（可复用组合）             │
│  ├── machines/ 机器类型模板 (wsl, desktop, server) │
│  └── roles/    用户角色模板 (coder, gamer, learner)│
├─────────────────────────────────────────────────────┤
│  features/     功能原子层（最小功能单元）           │
│  ├── nix/      Nix 相关 (nh, home-manager)         │
│  ├── sys/      系统基础 (network, input, user)     │
│  ├── tui/      终端应用 (shell, nvim, tmux)        │
│  ├── dev/      开发工具 (devenv, direnv, langs)    │
│  ├── ai/       AI 工具 (claude, codegen)           │
│  ├── gui/      图形界面 (remote, display)          │
│  ├── desktop/  桌面环境 (niri, gnome)              │
│  └── app/      应用程序                             │
└─────────────────────────────────────────────────────┘
```

### 2.1 Features（功能层）

功能模块是最小的配置单元，每个模块封装单一功能的完整实现。

**命名规范**：`feature/{category}/{name}`

**模块结构**：
```nix
# modules/features/nix/nh.nix
{ config, ... }:
let
  name = "feature/nix/nh";
in
{
  # NixOS 侧配置
  flake.modules.nixos.${name} = { pkgs, ... }: {
    programs.nh.enable = true;
  };

  # Home-Manager 侧配置
  flake.modules.homeManager.${name} = { ... }: {
    home.shellAliases.nos = "nh os switch .";
  };
}
```

**层次聚合**：父模块使用 `isDirectSubmodule` 自动导入直接子模块：
```nix
# modules/features/nix/default.nix
{ config, lib, ... }:
let
  name = "feature/nix";
  inherit (config.flake.aor.lib) isDirectSubmodule;
  modules = config.flake.modules.nixos;
in
{
  flake.modules.nixos.${name} = {
    imports = lib.pipe modules [
      builtins.attrNames
      (builtins.filter (isDirectSubmodule name))
      (map (n: modules.${n}))
    ];
  };
}
```

### 2.2 Prototypes（原型层）

原型是功能模块的预设组合，定义某类机器或用户角色的标准配置。

**机器原型**（仅 nixos）：
- `machine/common`：所有机器的基础配置
- `machine/wsl`：WSL2 环境特有配置
- `machine/desktop`：桌面环境配置
- `machine/server`：服务器配置

**角色原型**（仅 homeManager）：
- `role/common`：所有用户的基础配置
- `role/coder`：开发者工具集
- `role/gamer`：游戏相关配置

**继承规则**：
```
machine/wsl    → imports [machine/common]
machine/server → imports [machine/common]
role/coder     → imports [role/common]
```

### 2.3 Profiles（配置层）

具体的机器和用户配置，触发 configuration 的自动生成。

**机器配置**：`host/{hostname}`
```nix
# modules/profiles/hosts/Amanojaku/Amanojaku.nix
{ config, ... }:
let
  name = "host/Amanojaku";
in
{
  flake.meta.hosts.Amanojaku = {
    type = "wsl";      # 关联 machine/wsl 原型
    system = "x86_64-linux";
    features = {
      cuda = true;     # 机器特有属性
    };
  };

  flake.modules.nixos.${name} = { hostConfig, ... }: {
    networking.hostName = "Amanojaku";
    # 机器特定配置...
  };
}
```

**用户配置**：`user/{username}`
```nix
# modules/profiles/users/aor/aor.nix
{ config, ... }:
let
  name = "user/aor";
in
{
  flake.meta.users.aor = {
    hosts = [ "Amanojaku" "Bakotsu" "Chimi" ];  # 部署目标
    roles = [ "coder" "gamer" ];                # 关联角色原型
  };

  flake.modules.homeManager.${name} = { userConfig, hostConfig, ... }: {
    home.username = "aor";
    # 用户特定配置...
  };
}
```

---

## 3. 配置传递机制

### 3.1 配置数据存储

功能模块的配置数据定义在 `flake.modules.parts.${name}` 下，由 flake-parts 模块传递给内部的 nixos/home-manager 模块。

```nix
# modules/features/dev/git.nix
{ config, ... }:
let
  name = "feature/dev/git";
  cfg = config.flake.modules.parts.${name};
in
{
  # 配置数据定义
  flake.modules.parts.${name} = {
    users.aor = {
      email = "aor@example.com";
      signing = true;
    };
  };

  # Home-Manager 模块使用配置
  flake.modules.homeManager.${name} = { userConfig, ... }:
  let
    userCfg = cfg.users.${userConfig.name} or {};
  in
  {
    programs.git = {
      userEmail = userCfg.email or "";
      signing.signByDefault = userCfg.signing or false;
    };
  };
}
```

### 3.2 上下文参数

内部模块导入 configuration 时可访问的特殊参数：

| 参数 | 作用域 | 说明 |
|------|--------|------|
| `hostConfig` | nixos, homeManager | 当前机器的 meta 信息 |
| `userConfig` | homeManager | 当前用户的 meta 信息 |

**hostConfig 示例**：
```nix
flake.modules.nixos."feature/sys/gpu" = { hostConfig, ... }: {
  # 根据机器特性启用 CUDA
  hardware.nvidia.enable = hostConfig.features.cuda or false;
};
```

**userConfig 示例**：
```nix
flake.modules.homeManager."feature/tui/shell" = { userConfig, hostConfig, ... }: {
  # 根据用户角色和机器类型调整配置
  programs.zsh.shellAliases = {
    dev = lib.mkIf (builtins.elem "coder" userConfig.roles) "cd ~/dev";
  };
};
```

---

## 4. 目录结构

```
.
├── flake.nix              # 入口：import-tree ./modules
├── flake.lock
├── modules/               # 所有模块（自动导入）
│   ├── metas/             # 框架元配置
│   │   ├── flake-parts/   # flake-parts 基础设置
│   │   ├── framework/     # configuration 自动生成逻辑
│   │   └── lib/           # 工具函数 (isDirectSubmodule 等)
│   ├── features/          # 功能模块
│   ├── prototypes/        # 原型模板
│   │   ├── machines/
│   │   └── roles/
│   └── profiles/          # 具体配置
│       ├── hosts/
│       └── users/
├── overlays/              # 包覆盖层
├── flakes/                # 独立子 flake (如 lazyvim)
├── secrets/               # sops 加密的敏感数据
└── devshells/             # 开发环境配置
```

---

## 5. 自动化机制

### 5.1 Configuration 生成

**NixOS Configurations**：
- 扫描 `flake.modules.nixos` 中 `host/*` 命名的模块
- 为每个 host 生成 `nixosConfigurations.{hostname}`
- 自动导入对应 `machine/{type}` 原型

**Home Configurations**：
- 扫描 `flake.modules.homeManager` 中 `user/*` 命名的模块
- 为每个 user×host 组合生成 `homeConfigurations.{user}@{host}`
- 自动导入对应 `role/*` 原型

### 5.2 模块聚合

每个目录的 `default.nix` 自动聚合直接子模块：
```
feature/tui/default.nix → 自动导入 feature/tui/shell, feature/tui/nvim, ...
feature/tui/nvim/default.nix → 自动导入 feature/tui/nvim/plugins, ...
```

新增功能只需创建文件，无需修改父级导入列表。

---

## 6. Flake 输出

### 6.1 Configurations

```nix
nixosConfigurations = {
  Amanojaku = ...;   # 家庭 PC (WSL2 + CUDA)
  Bakotsu = ...;     # 公司 PC (WSL2)
  Chimi = ...;       # 家庭服务器
};

homeConfigurations = {
  "aor@Amanojaku" = ...;
  "aor@Bakotsu" = ...;
  "aor@Chimi" = ...;
};
```

### 6.2 Development Shells

采用 devenv + flake-parts 方案：
- `devShells.{system}.default`：通用开发环境
- `devShells.{system}.{name}`：特定项目环境

### 6.3 Packages（规划中）

导出可复用的包和模块供外部使用。

---

## 7. 设计原则总结

1. **功能聚合**：相关的 nixos/home-manager 配置与数据放在同一文件
2. **配置分离**：配置数据存于 `flake.modules.parts`，通过上下文参数传递
3. **导出纯净**：对外模块不依赖内部上下文（hostConfig 等）
4. **层次清晰**：features → prototypes → profiles 的依赖方向
5. **自动发现**：新增模块自动被系统发现和导入

---

## 参考资料

- [Dendritic Pattern](https://github.com/mightyiam/dendritic)
- [flake-parts](https://flake.parts/)
- [Dendrix 社区项目](https://github.com/vic/dendrix)
- [flake-parts and dendritic nix](https://blog.decent.id/post/flake-parts-and-dendritic-nix/)
