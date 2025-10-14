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
  - `metas/framework/`: Framework definitions
  - `features/`: Feature-specific modules (packages, services, UI tools)
  - `prototypes/homes/`: Home-manager configuration templates
  - `prototypes/hosts/`: NixOS configuration templates
  - `profiles/machines/`: Machine-specific configurations (Amanojaku, Bakotsu, Chimi)
  - `profiles/users/`: User-specific configurations
- **`/flakes`**: Custom flake definitions
- **`/overlays`**: Custom package overlays
- **`/devshells`**: Development environments (uses devenv.io)

### Build System
- **Entry Point**: `flake.nix` imports all modules via `inputs.import-tree ./modules`
- **Auto-Import**: All Nix files in `modules/` are automatically integrated
- **Module Naming**: Hierarchical naming organizes system structure (e.g., `features/tui/nvim`, `profiles/machines/Amanojaku`)

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

### Module Creation
- All modules must be placed in `/modules`
- Naming follows hierarchical system: `{category}/{subcategory}/{name}.nix`
- Example: `features/tui/nvim/nvf.nix`, `profiles/machines/Amanojaku/configuration.nix`

### Feature Modules
- Prefix: `features/` for reusable functionality
- Example features: `tui` (terminal UI), `networking`, `development`
- Each feature can depend on other features and framework components

### Prototype Modules
- `prototypes/homes/`: Reusable home-manager configurations
- `prototypes/hosts/`: Reusable NixOS configurations
- These are templates combined with specific features

### Profile Modules
- `profiles/machines/`: Concrete machine configurations
- `profiles/users/`: Concrete user configurations
- Profiles combine prototypes and features into specific deployments

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