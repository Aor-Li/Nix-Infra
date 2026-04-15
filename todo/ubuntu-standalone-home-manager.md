# TODO: Ubuntu Standalone Home-Manager 支持

## 概述

在现有框架中支持非 NixOS（Ubuntu 等）机器的用户环境配置。通过新增 `distro` option 标识机器的系统发行版，当 `distro` 不是 `"nixos"` 或 `"darwin"` 时，flake 不提供系统 configuration，仅根据 hostname 生成 `homeConfigurations."user@host"`。

---

## Phase 1: 框架 distro 扩展

- [x] **为 hostType 新增 `distro` option**
  - 文件: `modules/profiles/default.nix`
  - 改动: 在 `hostType` 中添加 `distro` option（类型 `types.enum ["nixos" "ubuntu" "arch" "darwin"]`，默认 `"nixos"`）
  - 语义: `"nixos"` / `"darwin"` 表示由 flake 管理系统配置；其余值（`"ubuntu"` / `"arch"` 等）表示仅提供 home-manager 配置
  - 注意: `type` 保持不变（`desktop` / `laptop` / `server` / `vm` / `wsl`），`distro` 与 `type` 正交
  - 额外: 现有三个 host profile（Amanojaku, Bakotsu, Chimi）已显式添加 `distro = "nixos"`

- [x] **修改 `configuration-nixos.nix`，按 distro 过滤**
  - 文件: `modules/metas/framework/configuration-nixos.nix`
  - 改动: 在 `flake.nixosConfigurations` 生成逻辑中，用 `lib.filterAttrs` 仅对 `distro == "nixos"` 的 host 创建 `nixosConfiguration`
  - 这样 Ubuntu 等机器即使有 host profile 也不会被当作 NixOS 配置处理

## Phase 2: 机器元数据注册

- [ ] **创建机器元数据文件** `modules/profiles/machines/Ubume/Ubume.nix`
  - 设置 `flake.aor.meta.hosts.Ubume`（name, type, distro="ubuntu", system, owner）
  - **不设置** `modules.profile.host.Ubume`（不会生成 nixosConfiguration）

- [ ] **更新用户 hosts 列表**
  - 文件: `modules/profiles/users/aor/aor.nix`
  - 改动: `meta.users.aor.hosts` 添加 `"Ubume"`

## Phase 3: Role Prototype 拆分

- [ ] **拆分 `role.common`** 为 `role.base` + `role.desktop`
  - 新建 `modules/prototypes/roles/base.nix`: 导入 `feature.{ai,nix,dev,sys,network}.home`（核心功能，无桌面）
  - 新建 `modules/prototypes/roles/desktop.nix`: 只导入 `feature.desktop.home`（桌面功能）
  - 修改 `modules/prototypes/roles/common.nix`: 改为导入 `role.base + role.desktop`（向后兼容）
  - 解决 imports 静态性问题：user profile 对非 NixOS distro -> `role.base`，NixOS 桌面 -> `role.common`

- [ ] **更新 user profile imports**
  - 文件: `modules/profiles/users/aor/aor.nix`
  - 方案: 全部导入 `role.base`，desktop features 内部用 `hostConfig.distro` 做条件守卫
  - 或者在不同 role 中区分 distro 导入

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
| `modules/profiles/default.nix` | 修改 | hostType 新增 `distro` option |
| `modules/metas/framework/configuration-nixos.nix` | 修改 | 按 `distro` 过滤，仅为 nixos 生成 nixosConfiguration |
| `modules/profiles/machines/Ubume/Ubume.nix` | 新建 | 注册 meta.hosts（distro="ubuntu"） |
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

- **新增 `distro` option 而非修改 `type`** — `type` 描述机器形态（desktop/server/…），`distro` 描述操作系统发行版（nixos/ubuntu/…），两者正交
- **`distro` 默认 `"nixos"`** — 向后兼容，现有不设 distro 的 host 行为不变
- **`configuration-nixos.nix` 过滤** — 从源头控制：只有 `distro == "nixos"` 的 host profile 才进入 `nixosConfigurations`
- **复用 `meta.hosts`** — 不创建新命名空间，`profiles/machines/` 与 `profiles/hosts/` 目录分离提供语义区分
- **无需修改 `configuration-home.nix`** — 当前逻辑已完全支持（遍历所有 user 的 hosts，不区分 distro）

## Further Considerations

1. **imports 静态性**: 推荐在 desktop features 的 home 实现中添加 `lib.mkIf (hostConfig.distro == "nixos")` 守卫
2. **多台非 NixOS 机器差异化**: proxy 等通过各自 `meta.hosts.X` freeform attributes 提供
3. **Nix 安装是前置条件**，不属于框架改动范围
4. **未来 darwin 支持**: 若需支持 macOS，可用 `distro == "darwin"` 配合类似的 `configuration-darwin.nix` 过滤逻辑
