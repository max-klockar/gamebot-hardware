# Hardware bring-up checklist (Pi 4B)

For a full package/apt/venv bake list (future SD image), see [pi-image.md](pi-image.md).

When parts arrive:

1. Flash Raspberry Pi OS 64-bit, enable camera + I2C/SPI as needed.
2. Connect Picam v3 Wide CSI, projector via HDMI, LED strip per [led-wiring.md](led-wiring.md) (5V/GND from WAGO, yellow → pin 12 / BCM 18; fan keeps pins 4 + 6).
3. Soft power-off: wire front momentary **Power** between pin 5 (BCM 3) and GND; add `dtoverlay=gpio-shutdown,...` per [power-safe.md](power-safe.md). Label C8 rocker **Mains isolator** — button first, rocker second (protects the SD).
4. On the Pi:

```bash
cd gamebot
python -m venv .venv && source .venv/bin/activate
# Camera: use apt picamera2/libcamera (pip picamera2 alone fails — no libcamera).
sudo apt install -y python3-picamera2 python3-libcamera
# Prefer creating the venv with system site packages so imports work:
#   python3 -m venv --system-site-packages .venv
pip install -e ".[pi-led,dev]" pygame -e "../chess-plugin"
# Do NOT pip install picamera2 into the venv if apt already provides it.
# Install Stockfish: sudo apt install stockfish
gamebot --camera picam --projector hdmi
```

5. First boot: run calibration (`c` / Done). Confirm projected grid aligns with board edges.
6. Tune `dwell_ms`, projector keystone/throw for stable CV. See [projector-hy300.md](projector-hy300.md) for throw (≥80 cm), fan noise / ambience, and automating the HDMI remote sequence (IR blaster).
7. LED ring: soft blue at idle, purple while Stockfish thinks, violent red if SoC ≥ 75°C. Headless check (no projector): `sudo .venv/bin/python -m gamebot.bringup --led-demo --loop`. Auto-start of full `gamebot.service` is optional and **not** enabled by default — see [deploy/README.md](deploy/README.md).
8. Fan is passive hardware; keep intake clear. No software control required for Noctua 12V unless you add a PWM controller later.
9. Test Power button → clean halt → ACT LED off → then rocker. Never yank rocker while the Pi is up.
10. **Before lending to chess clubs / schools:** follow [SECURITY.md](SECURITY.md) — replace personal GitHub SSH keys with read-only per-repo deploy keys.

Mock development continues with `gamebot --mock` on a laptop until this checklist is done.
