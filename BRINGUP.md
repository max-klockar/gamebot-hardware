# Hardware bring-up checklist (Pi 4B)

When parts arrive:

1. Flash Raspberry Pi OS 64-bit, enable camera + I2C/SPI as needed.
2. Connect Picam v3 Wide CSI, projector via HDMI, LED ring via MOSFET on BCM 18 (optional).
3. On the Pi:

```bash
cd gamebot
python -m venv .venv && source .venv/bin/activate
pip install -e ".[pi,dev]" -e "../chess-plugin"
# Install Stockfish: sudo apt install stockfish
gamebot --camera picam --projector hdmi
```

4. First boot: run calibration (`c` / Done). Confirm projected grid aligns with board edges.
5. Tune `dwell_ms`, projector keystone/throw for stable CV.
6. LED ring: soft blue at idle, purple while Stockfish thinks, violent red if SoC ≥ 75°C (`/sys/class/thermal/thermal_zone0/temp`). Demo with `python -m gamebot.bringup --led-demo`.
7. Fan is passive hardware; keep intake clear. No software control required for Noctua 12V unless you add a PWM controller later.

Mock development continues with `gamebot --mock` on a laptop until this checklist is done.
