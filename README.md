# NixOS Flake Update Guide

Questa repo usa i flake con `flake.lock`: i rebuild sono riproducibili finche il lock non cambia.

## Regola base

- `sudo nixos-rebuild switch --flake /etc/nixos#nixos` usa automaticamente `flake.lock`. Usa l'alias nrs per usarlo 
- Se non lanci `nix flake update`, le versioni restano bloccate.

## Workflow sicuro di update

Usa sempre questi comandi (con feature flags esplicite):

```bash
nix --extra-experimental-features 'nix-command flakes' flake update nixpkgs /etc/nixos
nix --extra-experimental-features 'nix-command flakes' flake update home-manager /etc/nixos
sudo nixos-rebuild test --flake /etc/nixos#nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

Se il test fallisce, non fare `switch`: il sistema attuale resta invariato.

## Passare a branch stabile 25.11

1. Modifica `flake.nix`:
   - `nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";`
   - `home-manager.url = "github:nix-community/home-manager/release-25.11";`
2. Aggiorna il lock:

```bash
nix --extra-experimental-features 'nix-command flakes' flake update /etc/nixos
```

3. Verifica e applica:

```bash
sudo nixos-rebuild test --flake /etc/nixos#nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Rollback rapido

Se qualcosa va storto dopo uno switch:

```bash
sudo nixos-rebuild switch --rollback
```

Oppure scegli la generazione precedente dal bootloader.
