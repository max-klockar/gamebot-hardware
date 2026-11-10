# Hardware bring-up checklist (Pi 4B)

For a full package/apt/venv bake list (future SD image), see [pi-image.md](pi-image.md).

When parts arrive:

1. Flash Raspberry Pi OS 64-bit, enable camera + I2C/SPI as needed.
2. Connect Picam v3 Wide CSI, projector via HDMI, LED strip per [led-wiring.md](led-wiring.md) (5V/GND from WAGO, yellow → pin 12 / BCM 18; fan keeps pins 4 + 6).
3. On the Pi:

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

4. First boot: run calibration (`c` / Done). Confirm projected grid aligns with board edges.
5. Tune `dwell_ms`, projector keystone/throw for stable CV. See [projector-hy300.md](projector-hy300.md) for throw (≥80 cm), fan noise / ambience, and automating the HDMI remote sequence (IR blaster).
6. LED ring: soft blue at idle, purple while Stockfish thinks, violent red if SoC ≥ 75°C. Headless check (no projector): `sudo .venv/bin/python -m gamebot.bringup --led-demo --loop`. Auto-start of full `gamebot.service` is optional and **not** enabled by default — see [deploy/README.md](deploy/README.md).
7. Fan is passive hardware; keep intake clear. No software control required for Noctua 12V unless you add a PWM controller later.
8. **Before lending to chess clubs / schools:** follow [SECURITY.md](SECURITY.md) — replace personal GitHub SSH keys with read-only per-repo deploy keys.

Mock development continues with `gamebot --mock` on a laptop until this checklist is done.
