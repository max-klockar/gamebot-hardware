# Deploy on the Pi

Assumes clones at `~/src/gamebot`, `~/src/gamebot-plugin-chess`, and this repo at `~/src/gamebot-hardware`.

**Preferred (public repos):** HTTPS remotes, **no** GitHub SSH key on the Pi. See [SECURITY.md](../SECURITY.md).

```bash
cd ~/src
git clone https://github.com/max-klockar/gamebot-hardware.git
# if already cloned via SSH:
# git -C gamebot-hardware remote set-url origin https://github.com/max-klockar/gamebot-hardware.git

chmod +x ~/src/gamebot-hardware/deploy/gamebot-update.sh

sudo cp ~/src/gamebot-hardware/deploy/gamebot.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.timer /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now gamebot-update.timer
# Operator page on boot (http://<pi>:8080). Needs the desktop session for the projector.
# Recopy the unit first — it runs the real camera, as root, and waits for the page.
# sudo systemctl enable --now gamebot.service

# Optional — LED-only pulse demo on boot (bring-up; no projector needed):
# sudo cp ~/src/gamebot-hardware/deploy/gamebot-led-demo.service /etc/systemd/system/
# sudo systemctl daemon-reload
# sudo systemctl enable --now gamebot-led-demo.service

systemctl list-timers | grep gamebot
~/src/gamebot-hardware/deploy/gamebot-update.sh
```

Update script only **ff-only** merges `main`. Develop on the Mac; don’t commit on the Pi.

LED pinout: [led-wiring.md](../led-wiring.md).
