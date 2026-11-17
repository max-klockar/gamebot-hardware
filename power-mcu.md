# MCU soft power (companion On/Off) — v2

**v1 (no wiring):** companion → Pi `shutdown -h`; wake by rocker **off then on**.
See [../plan.md](../plan.md). Build that first.

**v2 (this doc):** always-on Wi‑Fi MCU (spare Arduino/ESP) so the companion can
**wake the Pi after soft-off** while the **rocker stays ON**. Cold start = flip
rocker.

**Do not reopen the glued WAGO tree.** Feed the MCU from the existing
**Mean Well 5V** (sockerbitar). Switch only the **Pi PSU** path.

See also [power-safe.md](power-safe.md), [power-wiring.html](power-wiring.html).

## UX (reminder)

| You want | Action |
|----------|--------|
| Cold on (mains was off) | Flip **rocker** |
| Soft off | App/GPIO → Pi `shutdown -h` → MCU **cuts Pi power only** |
| Soft on (rocker already on) | App → MCU **restores Pi power** → boot |
| Travel / full dark | Soft off first, then rocker |

## Connection plan (preferred)

```
C8 / rocker
    │
    ├─ WAGO L+N ──► projector          (unchanged)
    │            ├─► Mean Well AC      (unchanged)
    │            └─► female EU ──► [RELAY NO] ──► official Pi PSU ──► Pi USB-C
    │
    └─ (via Mean Well 5V out / sockerbitar)
           +5V / GND ──► MCU (always on while rocker ON)
           MCU GPIO ──► relay coil (optocoupled module preferred)
```

### 1) Power the MCU — Mean Well, not Pi, not new WAGO

| MCU pin | From |
|---------|------|
| VIN / 5V | Mean Well **+5V** on existing **sockerbitar** (same rail as LEDs) |
| GND | Mean Well **GND** on sockerbitar (bond with LED GND) |

- Current: typically **<200 mA** — fine on APV-35-5 next to the strip.
- **Never** power the MCU from the Pi USB header (dead when soft-off).
- If the board is 3.3V-only: use its 5V→3.3 regulator input on VIN, or a tiny buck; don’t feed 5V into a 3.3V pin.

### 2) Switch the Pi — relay on the **female-EU → Pi PSU** live only

| Relay | Wire |
|-------|------|
| Contact **COM** | Live (brown) coming from WAGO toward female EU |
| Contact **NO** | Live continuing into female EU (or into Pi PSU IEC) |
| Neutral (blue) | Unswitched, continuous |

- Use a **mains-rated** relay module (≥5 A / 250 VAC), preferably optocoupled, with
  screw terminals. Pi brick is ~15 W — easy load.
- Insulate every splice (**heat-shrink** OK — that does **not** affect Wi‑Fi).
- Default **soft-off = coil off = NO open = Pi dark**. On boot after rocker flip,
  firmware should **energize relay** so Pi comes up with the box (or energize on
  first “On” — pick one and stick to it; recommended: **relay ON whenever rocker
  is on until soft-off**).

Alternative (more fiddly): switch **5V after** the Pi PSU USB-C. Avoid unless you
know PD/VBUS behaviour — official Pi bricks are happier switched on the AC side.

### 3) Logic / software (MCU stays dumb)

1. Companion (or local button path) asks Pi to halt (HTTP/SSH/`shutdown`).
2. Wait until Pi is down (timeout + optional ACT sense later).
3. MCU drops relay → Pi PSU dead.
4. Companion **On** → MCU closes relay → Pi boots.
5. No chess/game logic on the MCU.

GPIO soft-off button on the Pi can stay as today; optionally wire a second
button into the MCU for “Off” when the Pi is already dead (cut only / On).

## Wi‑Fi / “heating tube” / placement

| Do | Don’t |
|----|--------|
| Mount MCU in **plastic** or open air near the glass / vent | Seal it inside a **metal tube / tin / tight steel conduit** (Faraday → Wi‑Fi dies) |
| Keep the antenna / PCB edge toward room / glass door | Stuff antenna against Mean Well chassis or projector metal |
| Heat-shrink on **mains splices** — fine, RF-irrelevant | Run antenna parallel to long mains runs if you can avoid it |
| 2.4 GHz same as phone; a few metres to the table is enough | Expect perfect RSSI next to the HY300 PSU brick |

A **heating tube / heater element** in the box (if you add one for humidity etc.)
won’t “block” Wi‑Fi by being warm; **PWM / switching heaters** can add noise.
Keep MCU ≥10–15 cm away and on the Mean Well rail with decent decoupling.
Projector + Mean Well already dominate EMI — MCU Wi‑Fi usually still works if
the antenna isn’t in a metal pocket.

## Parts to add (BOM)

| Part | Notes |
|------|--------|
| Wi‑Fi MCU you already have | ESP8266 / ESP32 / Arduino Wi‑Fi — 5V-tolerant supply path |
| 1-channel relay module 5V coil, mains contacts | Optocoupler + NO contact for Pi PSU live |
| Short leads + heat-shrink | Splice only on female-EU live, service loops |
| Optional: terminal extender on sockerbitar | Extra +5V/GND taps for MCU |

## Install order

1. Soft-off Pi, rocker off, unplug C8.
2. Tap Mean Well sockerbitar → MCU 5V/GND; confirm MCU boots with rocker on / Pi unplugged.
3. Insert relay in **female EU live** only; neutrals untouched; heat-shrink splices.
4. Firmware: soft-off sequence + On restores relay; after power loss, define
   default relay state (recommend **ON** so rocker cold-start boots the Pi).
5. Test: rocker on → Pi boots; soft-off → Pi dies, LEDs/projector/MCU stay up;
   app On → Pi returns; rocker off → everything dead.

## Explicit non-goals

- No third WAGO, no reopening brown/blue mains tree for MCU power
- No switching projector or Mean Well for soft-off (rocker does full dark)
- No game logic / Stockfish / camera on the MCU
