# AGENTS.md

This repository contains a flake-based NixOS configuration with integrated Home Manager and a shared Neovim setup.

## Project Structure

- `flake.nix`: flake inputs/outputs and host definitions.
- `hosts/`: host entrypoints.
  - `hosts/personal-pc/default.nix`: desktop machine.
  - `hosts/work-wsl/default.nix`: WSL machine.
- `modules/system/common/`: modules shared by all hosts.
- `modules/system/personal-pc/`: desktop-only system modules.
- `modules/system/work-wsl/`: WSL-only system modules.
- `modules/home/common/`: shared Home Manager modules.
- `modules/home/profiles/`: host-specific Home Manager overlays/profiles.
- `nvim/`: shared Neovim configuration managed from this repo.
- `secrets/` and `secrets.nix`: agenix-managed secrets.

## Composition Model

- `flake.nix` defines the `personal-pc`, `work-wsl`, and legacy `nixos` configurations.
- Each host imports:
  - shared system modules from `modules/system/common`
  - host-specific system modules from `modules/system/<host>`
  - a Home Manager profile from `modules/home/profiles`
- `modules/home/profiles/andrea-common.nix` provides the common Andrea user baseline and imports `modules/home/common`.

## Editing Preferences

When adding or modifying Nix code in this repository, prefer these conventions:

- Group repeated namespace assignments into a single attrset when practical.
  - Prefer `services = { ... };` over multiple `services.foo = ...;` assignments.
  - Prefer `xdg.configFile = { ... };` over multiple `xdg.configFile."..." = ...;` assignments.
  - Prefer `age = { ... };` when several `age.*` assignments belong together.
- Keep related attributes close together and ordered logically.
  - Main config before derived/supporting files.
  - Shared modules before host-specific details.
  - Within grouped attrsets, sort entries by purpose and readability rather than strict alphabetic order.
- Reduce duplication with small local helpers in `let` blocks when the shape is repeated.
  - Good examples: `mkOptionalAgeSecret`, `mkProfile`, or small data attrsets consumed by helpers.
- Prefer explicit, readable data structures over clever abstraction.
  - Use helpers only when they clearly reduce repetition without hiding intent.
- Preserve the current module layout.
  - Shared behavior belongs in `modules/system/common` or `modules/home/common`.
  - Host-specific behavior belongs in the matching host folder or profile.
- For Neovim config in `nvim/`, keep repo-local behavior explicit rather than relying on implicit upstream defaults when the repo intentionally overrides them.

## Style Notes

- Keep formatting consistent with existing Nix style: simple attrsets, short `let` helpers, minimal comments.
- Avoid introducing unnecessary indirection, renames, or large structural rewrites for small changes.
- Prefer reproducible tool configuration through Nix packages/modules when possible.
- Do not remove or rewrite unrelated user changes while refactoring.

## Validation Expectations

After significant Nix changes, prefer lightweight verification when possible:

- `nix eval` for small expression checks
- `nix flake check --no-build path:/etc/nixos`
- `sudo nixos-rebuild test --flake path:/etc/nixos#<host>` when appropriate

For Neovim changes, targeted headless checks are preferred when feasible.
