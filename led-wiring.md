# LED strip wiring (WS2812 / NeoPixel)

3-wire strips (black / red / yellow) are **addressable WS2812**, not plain RGB. Use the `ws2812` backend (BCM **18**).

This build: **90 LEDs**, label **40 mA/pcs** → plan for up to **~3.6 A / ~18 W** at 5 V (marketing “≤9 W” is typical glow, not PSU size). **Too much** for the Pi header/USB. Power from **Mean Well APV-35-5** (or similar) via **sockerbitar**; only data from the Pi. Full box diagram: [power-wiring.html](power-wiring.html).

Full header map: [pi-pin-layout.png](pi-pin-layout.png).

## Do not power from

| Source | Why not |
|--------|---------|
| Pi pin 2 / 4 (5V) | ~0.5–1 A safe budget left for add-ons; 1.8 A browns out Wi‑Fi/boot |
| Pi USB‑A port | Shared ~1.2 A budget, still the Pi’s PSU |
| Fan pins 4 + 6 | Reserved for the Noctua; also still Pi 5V |

## Connections (90 LED / ~9 W strip)

| Strip wire | Role | Goes to |
|------------|------|---------|
| **Red** | +5V | **Sockerbit 5V** ← Mean Well + (not Pi header) |
| **Black** | GND | **Sockerbit GND** ← Mean Well − — also bond to Pi GND |
| **Yellow** | Data (DIN) | Pi **pin 12** = **BCM 18** |

```
Mean Well 5V+ ──► sockerbit 5V  ──► LED red
Mean Well GND ──► sockerbit GND ──► LED black
                                 └► Pi GND (pin 6 or 9)

Pi pin 12 (BCM 18) ──► LED yellow (data only)
Fan stays on Pi pin 4 (5V) + pin 6 (GND)
```

Mains: **C8 inlet** (no earth) → **2× WAGO 221-415** (brown / blue) → projector, female EU for Pi PSU, Mean Well. See [power-wiring.html](power-wiring.html).

## Power notes

- PSU sizing: **5 V ≥ 2 A** minimum for this strip; **3 A** is comfortable headroom.
- Optional: inject 5V at both ends of long strips if the far end dims (less critical at status-glow brightness).
- WS2812 data is nominally 5V; Pi GPIO is 3.3V — usually OK. If colors glitch, add a level shifter on the data line.
- Tiny rings (≤ ~16 LEDs, dim) can live on Pi 5V; **this 90-LED strip cannot**.

## Software test (no projector needed)

```bash
cd ~/src/gamebot && source .venv/bin/activate
pip install -e ".[pi-led]"
sudo .venv/bin/python -m gamebot.bringup --led-demo --loop --led-count 90
```

May need `sudo` for ws281x DMA/PWM. Cycles soft blue → purple → red until Ctrl+C.

## Auto-start

`gamebot.service` is **prepared but not enabled by default** (see [deploy/README.md](deploy/README.md)). Optional LED demo unit: `deploy/gamebot-led-demo.service` (set `--led-count 90` in the unit before enabling).
