# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# NixOS (pc-fixe)
sudo nixos-rebuild switch --flake .#pc-fixe

# macOS/Darwin (MacBook)
darwin-rebuild switch --flake .#MacBook-Pro-de-Louis

# Format all nix files
nix fmt

# Enter development shell (provides nil, nixfmt, statix, deadnix)
nix develop

# Check flake validity
nix flake check

# Lint with statix
statix check .

# Find dead code with deadnix
deadnix .
```

## Architecture

This is a unified NixOS and nix-darwin configuration flake managing both Linux (pc-fixe) and macOS (MacBook) systems.

**Key structure:**
- `lib/default.nix` - System builders (`mkNixosSystem`, `mkDarwinSystem`) that wire together host configs with home-manager
- `hosts/<hostname>/configuration.nix` - Per-machine system configuration
- `modules/home/` - Shared home-manager modules imported by all systems

**System builder pattern:** Both `mkNixosSystem` and `mkDarwinSystem` in `lib/default.nix` share a common home-manager configuration via `mkCommonHomeManagerConfig`, ensuring consistent user environment across platforms.

**Home-manager integration:** Uses `useGlobalPkgs = true` and `useUserPackages = true`. All home modules are platform-aware via `pkgs.stdenv.isDarwin` checks where needed.

**Default user:** `llr` (hardcoded in lib and modules)
