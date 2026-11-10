# Pi image bake list

Everything to put on a golden SD / custom Imager image so the next box doesn’t rediscover deps. Keep this file updated when bring-up invents a new package or setting.

## Base OS

| Item | Value |
|------|--------|
| OS | Raspberry Pi OS **64-bit** (Bookworm or later) with desktop (needed for `DISPLAY=:0` + pygame fullscreen) |
| Hostname | `gamebot` |
| User | `max` |
| Locale / Wi‑Fi country | SE (or deploy locale) |
| Camera | `camera_auto_detect=1` in `/boot/firmware/config.txt` |
| Auto-login desktop | Recommended so HDMI projector has a session without a keyboard |

## apt packages

```bash
sudo apt update
sudo apt install -y \
  python3-pip \
  python3-venv \
  python3-picamera2 \
  python3-libcamera \
  stockfish \
  git
```

Notes:

- **`python3-picamera2` + `python3-libcamera`** — required. `pip install picamera2` alone fails (`No module named 'libcamera'`).
- **`stockfish`** — chess plugin engine.
- Optional later: `libcap-dev` only if you insist on building odd pip wheels; prefer apt camera stack.

## Python venv (critical flag)

```bash
mkdir -p ~/src && cd ~/src
git clone https://github.com/max-klockar/gamebot.git
git clone https://github.com/max-klockar/gamebot-plugin-chess.git
git clone https://github.com/max-klockar/gamebot-hardware.git

cd ~/src/gamebot
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install -U pip
pip install -e ".[pi-led]" pygame -e ../gamebot-plugin-chess
```

| Do | Don’t |
|----|--------|
| `--system-site-packages` so apt `picamera2` / `libcamera` import | Bare `python3 -m venv .venv` then `pip install picamera2` |
| `pip install -e ".[pi-led]" pygame` | `pip install -e ".[pi]"` unless you know you need the pip camera meta-deps |
| HTTPS remotes for club boxes | Personal GitHub SSH keys on the Pi — see [SECURITY.md](SECURITY.md) |

### Pip packages (venv)

From extras / installs we actually use:

| Package | Why |
|---------|-----|
| `gamebot` (editable) | Runtime |
| `chess-plugin` / `gamebot-plugin-chess` (editable) | Chess game |
| `RPi.GPIO` | via `[pi-led]` |
| `rpi-ws281x` | WS2812 strip (often needs **root**/sudo to run) |
| `pygame` | HDMI fullscreen projector (`HdmiProjector`) |
| `numpy`, `opencv-python-headless`, `python-chess` | gamebot core deps |

## systemd (from this repo)

```bash
chmod +x ~/src/gamebot-hardware/deploy/gamebot-update.sh
sudo cp ~/src/gamebot-hardware/deploy/gamebot.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now gamebot-update.timer
# Production app on boot (when ready):
# sudo systemctl enable --now gamebot.service
```

| Unit | Default on image? | Role |
|------|-------------------|------|
| `gamebot-update.timer` | **Yes** | ff-only pull `gamebot` every ~2 min; installs `[pi-led]` |
| `gamebot.service` | Optional | Runs app (today still mock flags in unit — update before enabling) |
| `gamebot-led-demo.service` | Optional bring-up | LED pulse; run as root for ws281x |

Update script path assumptions: `~/src/gamebot`, `~/src/gamebot-plugin-chess`, user `max`. See [deploy/README.md](deploy/README.md).

## Runtime env / smoke tests

```bash
export DISPLAY=:0   # pygame → HDMI projector

# LED (sudo for ws281x DMA)
sudo ~/src/gamebot/.venv/bin/python -m gamebot.bringup --led-demo --loop --led-count 90

# Camera still (no GUI)
rpicam-still -n --width 4608 --height 2592 --autofocus-mode continuous -t 3000 -o ~/board-hi.jpg

# Projector + mock camera
python -m gamebot.bringup --camera mock --projector hdmi --seconds 60

# Projector + real camera
python -m gamebot.bringup --camera picam --projector hdmi --seconds 60

# Auto colour-corner calibrate + verify (writes ~/cal_verify.jpg)
python -m gamebot.bringup --camera picam --projector hdmi --calibrate

# Full app
gamebot --camera picam --projector hdmi
```

## Hardware wiring (not in the image, but paired)

| Doc | Content |
|-----|---------|
| [power-wiring.html](power-wiring.html) | C8 inlet, 2× WAGO 415, Mean Well, Pi PSU female EU, LED 5V |
| [led-wiring.md](led-wiring.md) | WS2812 data BCM 18 / pin 12, external 5V, common GND |
| [projector-hy300.md](projector-hy300.md) | Throw ≥80 cm, noise, IR HDMI boot ritual |
| [pi-pin-layout.png](pi-pin-layout.png) | Header map |

Camera: **CSI** (not DSI). Module 3 Wide; longer FPC if mount needs it. Focus at height often needs `--lens-position` / continuous AF; FOV will look “zoomed out”.

## Network / access

- Wi‑Fi: prefer **2.4 GHz** for bring-up reliability in a box
- Tailscale optional (`gamebot` node); LAN SSH works without it once Wi‑Fi is up
- Hostname `.local` is flaky; Tailscale name / IP is more reliable when online

## Image build TODO (later)

- [ ] Flash base OS + Imager settings (user, wifi, hostname, SSH)
- [ ] First-boot script: apt packages, clones, venv, systemd enable
- [ ] Bake `DISPLAY=:0` into `gamebot.service` `Environment=`
- [ ] Switch `gamebot.service` ExecStart to `--camera picam --projector hdmi` (+ led) when ready
- [ ] IR blaster HDMI sequence on boot (projector)
- [ ] Document Stockfish path if not on `PATH`
- [ ] Club-safe remotes per [SECURITY.md](SECURITY.md)

## Changelog of pain (so we don’t repeat)

| Issue | Fix baked above |
|-------|-----------------|
| `opencv` `namedWindow` not implemented | pygame `HdmiProjector`; keep `opencv-python-headless` |
| `No module named 'libcamera'` | apt picamera2/libcamera + `--system-site-packages` |
| `No module named 'picamera2'` in venv | same |
| WS2812 / LED needs root | sudo or root systemd unit |
| Camera in DSI by mistake | CSI only; cable length |
| Pip `[pi]` pulls heavy camera deps | prefer `[pi-led]` + apt camera |
| Update timer doesn’t pull hardware repo | docs only on Pi via separate clone/pull |
