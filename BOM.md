# Hardware BOM

| Part | Notes |
|------|--------|
| Raspberry Pi 4B 4GB | Main compute |
| Raspberry Pi Camera Module 3 Wide | Underside board view |
| HY300-clone projector | HDMI overlay onto table/board |
| Noctua 12V fan | Box cooling — keeps overheat red rare |
| LED ring (RGB / NeoPixel) | Soft blue idle, purple pulse when thinking, violent red if SoC ≥ 75°C |
| Glass door | See into box / LED glow |
| VESA arm mount | Position box over table |

LED wiring: WS2812 data on BCM 18, or discrete RGB on BCM 17/27/22 via MOSFETs (`ws2812` / `rgb_pwm` backends).

See also [camera-hole-fov.md](camera-hole-fov.md) for lens hole / countersink guidance.
