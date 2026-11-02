# LED strip wiring (WS2812 / NeoPixel)

3-wire strips (black / red / yellow) are **addressable WS2812**, not plain RGB. Use the `ws2812` backend (BCM **18**).

Full header map: [pi-pin-layout.png](pi-pin-layout.png).

## Avoid fan pins

Fan already uses physical **pin 4** (5V) and **pin 6** (GND). Use the other 5V/GND for the strip (or splice onto the same rails if you prefer — electrically fine; separate pins keep the header tidy).

## Connections

| Strip wire | Role | Pi header |
|------------|------|-----------|
| **Red** | +5V | **Pin 2** (5V) — not pin 4 |
| **Black** | GND | **Pin 9** (or 14, 20, …) — not pin 6 |
| **Yellow** | Data (DIN) | **Pin 12** = **BCM 18** |

```
Pi 40-pin (excerpt)          Strip / fan
─────────────────            ───────────
Pin 2  5V  ───────────────── Red (LED)
Pin 4  5V  ───────────────── Fan +
Pin 6  GND ───────────────── Fan −
Pin 9  GND ───────────────── Black (LED)
Pin 12 BCM18 ─────────────── Yellow (data)
```

## Power notes

- Small rings (≤ ~16 LEDs at moderate brightness): Pi 5V (pin 4) is usually OK.
- Longer / brighter strips: use a **separate 5V supply**, common GND with the Pi, still feed data from BCM 18.
- WS2812 data is nominally 5V; Pi GPIO is 3.3V — short strips usually still work. If colors glitch, add a level shifter on the data line.

## Software test (no projector needed)

On the Pi, after `pip install -e ".[pi]"` in the gamebot venv:

```bash
# may need sudo for PWM / DMA on ws281x
cd ~/src/gamebot && source .venv/bin/activate
sudo .venv/bin/python -m gamebot.bringup --led-demo --loop --led-count 16
```

Cycles soft blue → purple → red until Ctrl+C. Set `--led-count` to your strip length.

## Auto-start

`gamebot.service` is **prepared but not enabled by default** (see [deploy/README.md](deploy/README.md)). Full game on boot can wait until projector + mount are ready. For LED-only bring-up, run the demo command above (or enable a temporary unit later).
