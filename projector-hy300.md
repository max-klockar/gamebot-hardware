# HY300-clone projector — field notes

Cheap HDMI pico used for table overlay. Fine for bring-up; constraints below shape mount height, audio, and boot automation.

## Measured / observed constraints

| Issue | Observation | Implication |
|--------|-------------|-------------|
| Throw | **≥ ~80 cm** from table before a usable focus/image | Box cannot sit close; VESA arm / tall stand required. Image at min distance is still **small** — measure diagonal at your working height and confirm it covers board + UI margin |
| Fan noise | Loud continuous fan | Product UX should mask with ambience (Pi-driven speaker). Soft foam around chassis OK only if intake/exhaust stay clear — do not seal |
| Input select | Cold boot does **not** land on HDMI alone | Manual path: remote **On → Down → Right → Right → Right → OK** to HDMI. Machine is not unattended until this is automated |

Tune keystone after height is fixed; recalibrate (`gamebot` grid) whenever throw or angle changes.

## Why not directed lights / simple light signals instead?

**Short answer: no — not for this product.** Safe LEDs/spotlights cannot replace a projector here.

Gamebot assumes a **dense, arbitrary image** on the table: calibration dots, plugin chooser icons + hit-zones, chess scenes (highlights, illegal-move feedback, menus), and later other games. That needs many independently controllable pixels over a contiguous area.

| Approach | Safe? | Enough for gamebot? |
|----------|-------|---------------------|
| Status LED ring (already in BOM) | Yes | Machine state only — not table content |
| A few directed LEDs / desk spots | Yes | Coarse “glow here” at best; no icons, text, or dwell targets |
| Per-square light pipes / under-board LEDs | Yes | Chess-only highlight board; rebuilds the whole product; no generic plugins |
| Phone torch / single spotlight | Yes | One blob — useless for UI |
| Class-1 / toy laser + galvo | Borderline / often illegal without controls | Still not a full UI; user rule-out: no dangerous laser pointers |
| Projector (current) | Yes | Arbitrary frames via HDMI — matches `ProjectorAdapter` |

Directed light is a **different machine** (e.g. chess-only illuminated board). It is not a workaround for HY300 throw, noise, or HDMI boot. Stick with projection; fix throw with height, noise with audio + airflow, HDMI with IR (below). If a future SKU is chess-only with no projected UI, revisit under-board LEDs as a separate design.

## HDMI boot — automate the remote (preferred: IR blaster)

Do **not** require a human with the remote on every power-up.

1. **Check memory** — power-cycle after selecting HDMI once. If it returns to HDMI, document that and skip automation.
2. **IR blaster (recommended)** — IR LED from Pi (via transistor) aimed at the projector’s IR window. Learn codes for Power + Down + Right + OK; on `gamebot` / systemd start, replay the sequence with delays matching the OSD.
   - Capture: `ir-keytable` / LIRC / a cheap USB IR receiver, or phone IR apps that dump raw timings.
   - Emit: GPIO + IR LED, or a USB IR blaster.
3. **Hardwire remote (fallback)** — parallel Power / direction / OK traces to optocouplers or a tiny MCU that fires the same sequence. Use if IR is unreliable (sunlight, odd protocols).

CEC is unlikely on these clones; try `cec-ctl` once, don’t depend on it.

Track as bring-up: until HDMI is automatic, the box is not club/school ready.

## Mount / optical checklist

- [ ] Fix working distance ≥ 80 cm (or whatever this unit needs for focus).
- [ ] Measure projected width/height on the table; confirm board + UI fit.
- [ ] Keystone / focus; then run calibration.
- [ ] Confirm last-input memory **or** wire IR boot sequence into start services.
- [ ] Ambience path: speaker + quiet boot cue so fan noise is intentional, not a defect.
- [ ] Airflow: projector vents unobstructed inside the box.

## Related

- [BOM.md](BOM.md) — projector + VESA arm
- [BRINGUP.md](BRINGUP.md) — first HDMI bring-up
- `gamebot` `HdmiProjector` — fullscreen HDMI frames (no IR control yet)
