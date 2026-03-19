# NixOS Config (Flake)

Repo NixOS con struttura multi-host e Home Manager integrato.

## Host disponibili

- `personal-pc`: macchina principale desktop (GNOME, NVIDIA, gaming, audio).
- `work-wsl`: profilo per NixOS-WSL (terminale su Windows, senza stack desktop/hardware fisico).
- `nixos`: alias legacy che punta a `personal-pc`.

## Struttura repository

- `flake.nix`: input/output del flake (`nixpkgs`, `home-manager`, `nixos-wsl`).
- `hosts/`: entrypoint per host (`hosts/personal-pc/default.nix`, `hosts/work-wsl/default.nix`).
- `modules/system/common/`: moduli condivisi tra host (base, direnv, pacchetti comuni, tool Neovim).
- `modules/system/personal-pc/`: moduli solo desktop personale.
- `modules/system/work-wsl/`: moduli solo WSL.
- `modules/home/common/`: configurazioni Home Manager condivise (bash, fzf, neovim).
- `modules/home/profiles/`: differenze Home Manager per host.
- `nvim/`: configurazione Neovim condivisa e linkata in `~/.config/nvim` via Home Manager.

## Rebuild

Comandi espliciti:

```bash
sudo nixos-rebuild switch --flake path:/etc/nixos#personal-pc
sudo nixos-rebuild switch --flake path:/etc/nixos#work-wsl
```

Scorciatoia shell (definita in Home Manager):

```bash
nrs
nrs personal-pc
nrs work-wsl
```

`nrs` usa `hostname` se non passi argomenti.

## Aggiornamento lock file

Le versioni restano bloccate finche non aggiorni `flake.lock`.

```bash


nix flake update --flake /etc/nixos
nix flake check --no-build path:/etc/nixos
sudo nixos-rebuild test --flake path:/etc/nixos#personal-pc
sudo nixos-rebuild switch --flake path:/etc/nixos#personal-pc
```

Per WSL sostituisci l'host con `#work-wsl`.

## Rollback rapido

```bash
sudo nixos-rebuild switch --rollback
```

In alternativa, scegli una generazione precedente dal bootloader.
