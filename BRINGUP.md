# Hardware bring-up checklist (Pi 4B)

When parts arrive:

1. Flash Raspberry Pi OS 64-bit, enable camera + I2C/SPI as needed.
2. Connect Picam v3 Wide CSI, projector via HDMI, LED strip per [led-wiring.md](led-wiring.md) (yellow → pin 12 / BCM 18; fan keeps pins 4 + 6, LED uses pin 2 + another GND).
3. On the Pi:

```bash
cd gamebot
python -m venv .venv && source .venv/bin/activate
pip install -e ".[pi-led,dev]" -e "../chess-plugin"
# Camera later: sudo apt install libcap-dev && pip install -e ".[pi]"
# (or apt install python3-picamera2 and use a venv with --system-site-packages)
# Install Stockfish: sudo apt install stockfish
gamebot --camera picam --projector hdmi
```

4. First boot: run calibration (`c` / Done). Confirm projected grid aligns with board edges.
5. Tune `dwell_ms`, projector keystone/throw for stable CV. See [projector-hy300.md](projector-hy300.md) for throw (≥80 cm), fan noise / ambience, and automating the HDMI remote sequence (IR blaster).
6. LED ring: soft blue at idle, purple while Stockfish thinks, violent red if SoC ≥ 75°C. Headless check (no projector): `sudo .venv/bin/python -m gamebot.bringup --led-demo --loop`. Auto-start of full `gamebot.service` is optional and **not** enabled by default — see [deploy/README.md](deploy/README.md).
7. Fan is passive hardware; keep intake clear. No software control required for Noctua 12V unless you add a PWM controller later.
8. **Before lending to chess clubs / schools:** follow [SECURITY.md](SECURITY.md) — replace personal GitHub SSH keys with read-only per-repo deploy keys.

Mock development continues with `gamebot --mock` on a laptop until this checklist is done.
