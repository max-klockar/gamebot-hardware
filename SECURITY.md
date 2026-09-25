# Security model (club-safe)

Target setup:

1. **Source is public** (source-available, noncommercial license) — Pi pulls over **HTTPS**, no GitHub credentials on the box.
2. **Tailscale ACLs** — you can SSH *to* the Pi; the Pi cannot open connections *to* other tailnet devices.
3. **Lost/stolen Pi** — disable that node in Tailscale admin; rotate your personal SSH key if it was on the box.

That is “safe enough” for lending: no GitHub blast radius, limited Tailscale blast radius.

---

## Tailscale ACL (do this in admin console)

Open [login.tailscale.com/admin/acls](https://login.tailscale.com/admin/acls).

### 1. Tag the Pi

On the Pi:

```bash
sudo tailscale set --advertise-tags=tag:gamebot
```

In the admin UI, approve the tag if asked. Owners of `tag:gamebot` must be listed in `tagOwners` below (you/admins).

### 2. Policy (replace a wide-open “allow all” policy)

Example HuJSON — **only humans can reach gamebots; gamebots initiate nothing on the tailnet**:

```json
{
  "tagOwners": {
    "tag:gamebot": ["autogroup:admin"]
  },
  "acls": [
    // Your user(s) may reach Pis (SSH, etc.)
    {
      "action": "accept",
      "src": ["autogroup:member"],
      "dst": ["tag:gamebot:*"]
    }
    // No rule with "src": ["tag:gamebot", ...] ⇒ Pi cannot dial your laptop/NAS/etc.
  ]
}
```

Notes:

- Tailscale ACLs govern **tailnet peer traffic**, not the Pi’s normal Wi‑Fi to the internet. The Pi can still `apt` / `git pull` GitHub over Wi‑Fi.
- Do **not** enable Exit Node or subnet router on club Pis.
- If you have other devices that need to talk to each other, add explicit rules for those — don’t reintroduce “allow all”.

### 3. If a Pi is lost

1. Admin → Machines → that Pi → **Disable** or **Remove**.
2. Confirm you can no longer `ssh` to it via Tailscale.
3. If your personal SSH pubkey was on the Pi, you can leave it (disabled node can’t be reached usefully) or rotate later when re-imaging.

---

## GitHub: open source + no keys on the Pi

### On GitHub

Make public (example):

- `gamebot`
- `gamebot-plugin-chess`
- `gamebot-hardware`

### On the Pi

```bash
cd ~/src/gamebot
git remote set-url origin https://github.com/max-klockar/gamebot.git

cd ~/src/gamebot-plugin-chess
git remote set-url origin https://github.com/max-klockar/gamebot-plugin-chess.git

cd ~/src/gamebot-hardware
git remote set-url origin https://github.com/max-klockar/gamebot-hardware.git

# Remove GitHub SSH key material from the Pi
rm -f ~/.ssh/id_ed25519_github ~/.ssh/id_ed25519_github.pub
# If ~/.ssh/config only existed for GitHub, remove or edit that Host block

# Remove the same public key from https://github.com/settings/keys if it was an account key
```

Test pull (no SSH):

```bash
cd ~/src/gamebot && git pull
```

Your **Mac** can keep `git@github-priv:...` for pushing; only the Pi goes HTTPS.

### Interim (still private)

If you are not ready to go public: use **read-only deploy keys** per repo instead of an account key — see older notes below. Prefer public + no keys when lending.

---

## Deploy keys (only if repos stay private)

1. Remove account-level keys from the Pi and from github.com/settings/keys.
2. Repo → Settings → Deploy keys → read-only key per repo the box must pull.
3. Never put your Mac `priv` key on a loaner Pi.

---

## Checklist before lending to a club

- [ ] Repos public (or deploy keys only)
- [ ] No GitHub account SSH key / PAT on the Pi
- [ ] Pi tagged `tag:gamebot`
- [ ] ACL: members → `tag:gamebot`; no `tag:gamebot` → members
- [ ] You know how to disable the machine in Tailscale admin
- [ ] Pi SSH is key-based for *your* admin key only (optional: no password login)
