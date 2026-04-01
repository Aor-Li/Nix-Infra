# TODO: Ubuntu Standalone Home-Manager 支持

## 概述

在现有框架中支持非 NixOS（Ubuntu）机器的用户环境配置。仅注册 `meta.hosts` 元数据（不提供 NixOS 模块），利用 `configuration-home.nix` 已有机制生成 `homeConfigurations."user@host"`。

---

## Phase 1: 框架类型扩展

- [ ] **扩展 hostType 枚举**
  - 文件: `modules/profiles/default.nix`
  - 改动: `type` 添加 `"standalone"`（发行版无关命名，适用于任何非 NixOS Linux）

## Phase 2: 机器元数据注册

- [ ] **创建机器元数据文件** `modules/profiles/machines/Ubume/Ubume.nix`
  - 仅设置 `flake.aor.meta.hosts.Ubume`（name, type="standalone", system, owner）
  - **不设置** `modules.profile.host.Ubume`（这样不会生成 nixosConfiguration）

- [ ] **更新用户 hosts 列表**
  - 文件: `modules/profiles/users/aor/aor.nix`
  - 改动: `meta.users.aor.hosts` 添加 `"Ubume"`

## Phase 3: Role Prototype 拆分

- [ ] **拆分 `role.common`** 为 `role.base` + `role.desktop`
  - 新建 `modules/prototypes/roles/base.nix`: 导入 `feature.{ai,nix,dev,sys,network}.home`（核心功能，无桌面）
  - 新建 `modules/prototypes/roles/desktop.nix`: 只导入 `feature.desktop.home`（桌面功能）
  - 修改 `modules/prototypes/roles/common.nix`: 改为导入 `role.base + role.desktop`（向后兼容）
  - 解决 imports 静态性问题：user profile 对 standalone -> `role.base`，NixOS 桌面 -> `role.common`

- [ ] **更新 user profile imports**
  - 文件: `modules/profiles/users/aor/aor.nix`
  - 方案: 全部导入 `role.base`，desktop features 内部用 `hostConfig.type` 做条件守卫
  - 或者在不同 role 中区分 standalone 和 desktop 导入

## Phase 4: Feature 补充

- [ ] **补充 `nix/settings.nix` 的 home 实现**
  - 文件: `modules/features/nix/settings.nix`
  - 改动: 通过 home-manager 的 `nix.settings` 配置 experimental-features、substituters

- [ ] **补充 `network/vpn.nix` 的 home 实现**
  - 文件: `modules/features/network/vpn.nix`
  - 改动: 通过 `home.sessionVariables` 设置 proxy 环境变量

## Phase 5: 部署验证

- [ ] Ubuntu 安装 Nix: `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh`
- [ ] 安装 standalone home-manager
- [ ] `nix flake check` — 无 evaluation 错误
- [ ] `nix eval .#homeConfigurations --apply builtins.attrNames` — 输出包含 `"aor@Ubume"`
- [ ] `home-manager switch --flake .#aor@Ubume` — 验证配置正确应用
- [ ] 验证 proxy 环境变量、git/tmux/fish/neovim 等工具正常工作

---

## Relevant Files

| 文件 | 操作 | 说明 |
|------|------|------|
| `modules/profiles/default.nix` | 修改 | 扩展 hostType enum |
| `modules/profiles/machines/Ubume/Ubume.nix` | 新建 | 仅注册 meta.hosts |
| `modules/profiles/users/aor/aor.nix` | 修改 | hosts 列表 + role imports |
| `modules/prototypes/roles/base.nix` | 新建 | 无桌面的基础 role |
| `modules/prototypes/roles/desktop.nix` | 新建 | 桌面追加 role |
| `modules/prototypes/roles/common.nix` | 修改 | 改为 base + desktop |
| `modules/features/nix/settings.nix` | 修改 | 补充 home 实现 |
| `modules/features/network/vpn.nix` | 修改 | 补充 home 实现 |
| `modules/metas/framework/configuration-home.nix` | 不修改 | 已支持 |
| `modules/metas/framework/namespaces.nix` | 不修改 | 已支持 |

---

## Decisions

- **`"standalone"` 而非 `"ubuntu"`** — 类型名与发行版无关
- **复用 `meta.hosts`** — 不创建新命名空间，`profiles/machines/` 与 `profiles/hosts/` 目录分离提供语义区分
- **无需修改 `configuration-home.nix`** — 当前逻辑已完全支持

## Further Considerations

1. **imports 静态性**: 推荐在 desktop features 的 home 实现中添加 `lib.mkIf (hostConfig.type != "standalone")` 守卫
2. **多台 standalone 差异化**: proxy 等通过各自 `meta.hosts.X` freeform attributes 提供
3. **Nix 安装是前置条件**，不属于框架改动范围
