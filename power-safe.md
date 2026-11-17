# Safe power-off (Pi SD protection)

Hard-cutting the **C8 / rocker** while the Pi is running can corrupt the SD
(e.g. broken git objects mid-`pull`). Projector and Mean Well (LEDs) do **not**
need a graceful halt — only the Pi does.

Do **not** reopen the hot-glued WAGO mains tree for this. Keep
[power-wiring.html](power-wiring.html) as-is.

## Product UX

1. **Daily off:** press front **Power** (momentary) → clean `shutdown -h now` →
   wait until the Pi **ACT** LED stops → box is safe.
2. **Rocker / C8:** **Mains isolator** for travel/storage **after** the Pi has
   halted (or when already off). Do not label it “Power”.
3. Habit: **button first, rocker second**.

```
C8 / rocker ──► WAGO L+N ──► projector
                           ├─► female EU → Pi PSU → Pi 4B ◄── front button (GPIO)
                           └─► Mean Well 5V → WS2812
```

## Parts

| Part | Notes |
|------|--------|
| Momentary NO pushbutton | Panel-mount; illuminated optional |
| 2-wire to Pi header | Button → GPIO and GND; leave a service loop |

See [BOM.md](BOM.md).

## Wiring (no WAGO work)

| Button lead | Pi |
|-------------|-----|
| One side | **Pin 5** = **BCM 3** (I2C1 SCL) |
| Other side | **GND** — pin 9 preferred, or share pin 6 with fan GND |

- LED data stays **pin 12 / BCM 18** ([led-wiring.md](led-wiring.md)).
- Fan keeps pins **4 (5V) + 6 (GND)**.
- Route to a panel hole; DuPont/header end should unplug without touching WAGOs.

## Boot config

On Raspberry Pi OS Bookworm, edit `/boot/firmware/config.txt` and add:

```text
dtoverlay=gpio-shutdown,gpio_pin=3,active_low=1,gpio_pull=up
```

Reboot. Press and hold the button ~1s → kernel triggers shutdown. Works even if
gamebot is not running (no SSH required).

## Install order

1. `sudo shutdown -h now`, wait for ACT to stop, then cut the rocker.
2. Mount the button; wire pin 5 ↔ GND.
3. Add the dtoverlay; reboot; test button → halt; confirm ACT stops.
4. Label front **Power**, rocker **Mains isolator**.

## Later (optional)

If you want one control to go fully dark: after halt, auto-cut **Pi PSU only**
(`gpio-poweroff` + relay on the female-EU feed). Still leave WAGOs alone.
Projector/LEDs can die with the rocker.

**Product direction:** companion **v1** = Wi‑Fi soft-off only (wake = rocker
off/on, no new wires). **v2** = MCU soft-on — [power-mcu.md](power-mcu.md).
Notes in [../plan.md](../plan.md). Front GPIO button remains a local backup.

## Explicit non-goals

- No redesign of C8 / WAGO / Mean Well for this pass
- No “safe rocker” that hard-cuts the Pi without a prior halt
- No dependence on HDMI/projector UI for power-off
