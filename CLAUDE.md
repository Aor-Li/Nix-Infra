# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a multi-user, multi-machine Nix infrastructure monorepo using flake-parts with Dendritic-style module organization.

### Core Framework
- **flake-parts**: Module system built using flake-parts, automatically importing all Nix files in `/modules`
- **Dendritic Pattern**: Physical location doesn't affect build outcomes, but hierarchical naming maintains structure
- **Dynamic Loading**: Uses `inputs.import-tree ./modules` for automatic module discovery

### Directory Structure
- **`/modules`**: Auto-imported modules (key architecture):
  - `metas/flake-parts/`: flake-parts framework setup
  - `metas/framework/`: Framework definitions (nixosConfigurations from `host/*`, homeConfigurations from `user/*`)
  - `metas/lib/`: Utilities like `isDirectSubmodule` for hierarchical module detection
  - `features/`: Feature-specific modules (nix, sys, tui, dev, gui, app)
  - `prototypes/machines/`: Machine templates (common, wsl, desktop, server)
  - `prototypes/roles/`: User role templates (common, coder, gamer, learner)
  - `profiles/hosts/`: Concrete machine configurations (Amanojaku, Bakotsu, Chimi)
  - `profiles/users/`: Concrete user configurations
- **`/flakes`**: Custom flake definitions (e.g., lazyvim using nixCats)
- **`/overlays`**: Custom package overlays
- **`/devshells`**: Development environments (uses devenv.io)

### Build System
- **Entry Point**: `flake.nix` imports all modules via `inputs.import-tree ./modules`
- **Auto-Import**: All Nix files in `modules/` are automatically integrated
- **Config Generation**: Framework builds `nixosConfigurations` from `host/*` modules and `homeConfigurations` from `user/*` modules

## Common Commands

### Development
```bash
# Show available flake outputs
nix flake show

# Update flake inputs
nix flake update

# Build specific machine configuration
nix build .#nixosConfigurations.Amanojaku.config.system.build.toplevel

# Build user home configuration
nix build .#homeConfigurations.aor@Amanojaku.activationPackage

# Enter development shell for a specific context (when available)
nix develop .#<system-context>
```

### Testing
```bash
# Validate flake syntax
nix flake check

# Test module evaluation
nix-instantiate --eval --json ./modules

# Check system configurations
nix eval --impure --raw .#checks.x86_64-linux.Amanojaku
```

### Infrastructure Management
```bash
# Switch system configuration
nixos-rebuild switch --flake .#Amanojaku

# Switch home configuration
home-manager switch --flake .#aor@Amanojaku

# Build GPU-enabled system for Amanojaku (formerly CUDA machine)
nix build .#nixosConfigurations.Amanojaku-system-gpu.config.system.build.toplevel
```

## Module System Patterns

### Module Naming Convention
```
feature/{category}/{name}     -> features/{category}/{name}.nix
host/{hostname}               -> profiles/hosts/{hostname}/{hostname}.nix
user/{username}               -> profiles/users/{username}/{username}.nix
machine/{type}                -> prototypes/machines/{type}.nix
role/{type}                   -> prototypes/roles/{type}.nix
```

### Feature Module Pattern
Features register into `flake.modules.nixos` and/or `flake.modules.homeManager`:

```nix
{ ... }:
let
  name = "feature/nix/nh";
in
{
  flake.modules.nixos.${name} = { ... }: {
    programs.nh.enable = true;
  };
  flake.modules.homeManager.${name} = { ... }: {
    home.shellAliases.nos = "nh os switch .";
  };
}
```

### Special Arguments
- **`hostConfig`**: Access machine metadata (e.g., `hostConfig.type` for WSL detection)
- **`userConfig`**: Access user metadata (e.g., `userConfig.hosts` for target machines)

### Hierarchical Aggregation
Parent modules use `isDirectSubmodule` to auto-import immediate children:
```nix
isDirectSubmodule = module: sub:
  lib.hasPrefix "${module}/" sub &&
  !(lib.hasInfix "/" (lib.strings.removePrefix "${module}/" sub));
```

### Prototype vs Profile
- **Prototypes** (`machine/*`, `role/*`): Reusable templates that import feature sets
- **Profiles** (`host/*`, `user/*`): Concrete configurations that import prototypes and add specifics

## Important Context

### Machine Profiles
- **Amanojaku**: Primary PC (Win11/WSL2/NixOS + CUDA/CUDA support)
- **Bakotsu**: Company secure PC (Win11/WSL2/NixOS)
- **Chimi**: Mini-PC server (NixOS)

### Key Dependencies
- **nvf**: Neovim configuration framework (custom flake at `/flakes/lazyvim`)
- **sops-nix**: Secret management
- **nixos-wsl**: WSL2 integration
- **home-manager**: User environment management
- **nix-ai-tools**: AI/ML tooling dependencies