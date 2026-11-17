# gamebot-hardware

BOM, mounting, FOV notes, and Pi bring-up for the gamebot box.

- [pi-image.md](pi-image.md) — **bake list** for a golden Pi image (apt, venv, systemd, smoke tests)
- [pi-pin-layout.png](pi-pin-layout.png) — GPIO header reference
- [power-wiring.html](power-wiring.html) — mains WAGO + 5V sockerbitar + LED/Pi/projector
- [power-safe.md](power-safe.md) — front Power button (GPIO shutdown); rocker = cold isolator only
- [power-mcu.md](power-mcu.md) — Wi‑Fi MCU + relay for companion soft On/Off (Mean Well 5V, no new WAGO)
- [led-wiring.md](led-wiring.md) — WS2812 (~90 LEDs): 5V/GND from PSU, data pin 12

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md) — hobby / noncommercial OK; commercial use requires a separate license. See [NOTICE](NOTICE).
