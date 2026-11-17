# Hardware BOM

| Part | Notes |
|------|--------|
| Raspberry Pi 4B 4GB | Main compute |
| Raspberry Pi Camera Module 3 Wide | Underside board view |
| HY300-clone projector | HDMI overlay onto table/board — see [projector-hy300.md](projector-hy300.md) (throw ≥80 cm, noise, IR HDMI boot) |
| Noctua 12V fan | Box cooling — keeps overheat red rare |
| WS2812 strip (~90 LEDs, ~9 W) | Soft blue idle, purple pulse when thinking, violent red if SoC ≥ 75°C |
| Mean Well APV-35-5 (5V 5A) | Strip PSU — see [power-wiring.html](power-wiring.html) |
| IEC C8 inlet (figure-8) | Mains into box — L+N only, no earth |
| WAGO 221-415 ×2 | Brown (L) + blue (N) → projector, female EU (Pi PSU), Mean Well |
| Sockerbitar (LV) | 5V + GND from Mean Well → LED (+ Pi GND bond) |
| Glass door | See into box / LED glow |
| VESA arm mount | Position box over table |
| Momentary NO pushbutton | Front **Power** soft-off — BCM 3 / pin 5 (see [power-safe.md](power-safe.md)) |
| 2-wire + DuPont (or soldered) | Button ↔ pin 5 + GND; service loop at header |
| Wi‑Fi MCU (spare Arduino/ESP) | Soft On/Off with companion — [power-mcu.md](power-mcu.md) |
| Mains relay module (5V coil, ≥5A/250VAC NO) | Breaks female-EU **live** to Pi PSU only |

LED wiring: 5V/GND from WAGO, data BCM 18 — see [led-wiring.md](led-wiring.md).

Safe daily power-off (no WAGO surgery): [power-safe.md](power-safe.md). Label the C8 rocker **Mains isolator**, not Power.

See also [camera-hole-fov.md](camera-hole-fov.md) for lens hole / countersink guidance.
