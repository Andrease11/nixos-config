# agenix secrets

This directory contains host-specific secrets encrypted with `agenix`.

## Files

- `secrets.nix`: maps each encrypted file to the host key allowed to decrypt it.
- `*-github-hosts.yml.example`: plaintext templates for GitHub CLI secrets.
- `*.age`: encrypted secrets safe to commit and push.

## Key model

- Each host has its own private `age` key.
- `personal-pc` can decrypt only secrets encrypted for `personal-pc`.
- `work-wsl` can decrypt only secrets encrypted for `work-wsl`.
- Keep the user copy of keys in `~/.config/agenix/*.agekey` for backup and editing.
- Copy the matching key to `/etc/agenix/*.agekey` on each machine so NixOS can decrypt at activation time.

## Initial setup

Generate one key per host:

```bash
mkdir -p ~/.config/agenix
chmod 700 ~/.config/agenix

age-keygen -o ~/.config/agenix/personal-pc.agekey
age-keygen -o ~/.config/agenix/work-wsl.agekey
```

Print the public keys and paste them into `secrets/secrets.nix`:

```bash
age-keygen -y ~/.config/agenix/personal-pc.agekey
age-keygen -y ~/.config/agenix/work-wsl.agekey
```

Install the runtime key on each machine:

```bash
sudo install -d -m 700 /etc/agenix
sudo install -m 600 ~/.config/agenix/personal-pc.agekey /etc/agenix/personal-pc.agekey
sudo install -m 600 ~/.config/agenix/work-wsl.agekey /etc/agenix/work-wsl.agekey
```

Run only the command that matches the current host.

## Create or edit a secret

Use the host-specific alias from the matching machine:

```bash
agenix-personal -e secrets/personal-pc-github-hosts.yml.age
agenix-work -e secrets/work-wsl-github-hosts.yml.age
```

Paste the plaintext secret into the editor, save, and exit. `agenix` writes the encrypted `.age` file directly.

Example GitHub secret:

```yaml
github.com:
    users:
        your-user:
            oauth_token: gho_xxx
    git_protocol: https
    oauth_token: gho_xxx
    user: your-user
```

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#personal-pc
sudo nixos-rebuild switch --flake .#work-wsl
```

After rebuild, Home Manager links `~/.config/gh/hosts.yml` to the decrypted runtime secret in `/run/agenix/personalGithubHosts` or `/run/agenix/workGithubHosts`.

## Set up a future replacement PC

If you replace `personal-pc` or `work-wsl`, you do not need to re-encrypt the secrets if you still have that host's private key.

On the new machine:

1. Copy the right private key from your backup into `~/.config/agenix/`.
2. Install the same key into `/etc/agenix/`.
3. Rebuild the matching host config.

Example for a replacement `work-wsl` machine:

```bash
mkdir -p ~/.config/agenix
chmod 700 ~/.config/agenix
nano ~/.config/agenix/work-wsl.agekey
chmod 600 ~/.config/agenix/work-wsl.agekey

sudo install -d -m 700 /etc/agenix
sudo install -m 600 ~/.config/agenix/work-wsl.agekey /etc/agenix/work-wsl.agekey
sudo nixos-rebuild switch --flake .#work-wsl
```

The existing `secrets/work-wsl-*.age` files will keep working because they are still encrypted for the same public key.

## Add a new secret for an existing host

You do not need a new key if the secret belongs to an existing host.

1. Add a new entry in `secrets/secrets.nix` using the existing host public key.
2. Create the encrypted file with the matching host alias.
3. Reference the new secret from the host's NixOS or Home Manager module.
4. Rebuild that host.

Example for a new work secret:

```nix
"secrets/work-wsl-npm-token.age".publicKeys = [ workWsl ];
```

```bash
agenix-work -e secrets/work-wsl-npm-token.age
```

## What goes in git

- Commit: `secrets/*.age`, `secrets/secrets.nix`, templates, module changes.
- Do not commit: `*.agekey` or any plaintext secret file.

## Notes

- `personal-pc` cannot decrypt `work-wsl` secrets unless you copy the `work-wsl` private key there.
- `work-wsl` cannot decrypt `personal-pc` secrets unless you copy the `personal-pc` private key there.
