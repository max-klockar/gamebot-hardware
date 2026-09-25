# Security: SSH keys before lending a box out

Scary otherwise: a Pi with your **personal GitHub account SSH key** can read/write every private repo that key can access. Don’t lend a club machine in that state.

## Required before any club / third-party loan

1. **Remove account-level keys from the Pi**  
   Delete `~/.ssh/id_ed25519_github` (or whatever was added under github.com/settings/keys) from both the Pi **and** your GitHub account SSH keys list if it was a full account key.

2. **Use read-only Deploy keys scoped per repo**  
   For each repo the box needs (usually just `gamebot`, plus any installed plugins):
   - Repo → **Settings → Deploy keys → Add deploy key**
   - Allow write access: **off** (read-only)
   - One key per repo (GitHub requires unique deploy keys)

3. **Do not put your Mac `priv` / personal keys on loaner Pis**

4. **Optional hardening**
   - Separate GitHub machine user / fine-grained PAT only if you must use HTTPS
   - Tailscale ACL so only your account can SSH to club boxes
   - Disable password SSH; keep only your admin key (not shared with the club)

## Dev vs production mental model

| Context | Key type |
|---------|----------|
| Your home Pi while developing | Account SSH key OK (convenient) |
| Club / school / loaner box | Deploy keys only, read-only, minimal repos |

If a loaned Pi is lost: revoke that deploy key (or all keys for that box) immediately in GitHub.
