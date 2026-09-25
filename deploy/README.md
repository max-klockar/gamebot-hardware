# Deploy on the Pi

Assumes clones at `~/src/gamebot`, `~/src/gamebot-plugin-chess`, and this repo at `~/src/gamebot-hardware`.

```bash
cd ~/src
git clone git@github.com:max-klockar/gamebot-hardware.git

chmod +x ~/src/gamebot-hardware/deploy/gamebot-update.sh

sudo cp ~/src/gamebot-hardware/deploy/gamebot.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.service /etc/systemd/system/
sudo cp ~/src/gamebot-hardware/deploy/gamebot-update.timer /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now gamebot-update.timer
# Optional — start the app service when you want it always running:
# sudo systemctl enable --now gamebot.service

systemctl list-timers | grep gamebot
~/src/gamebot-hardware/deploy/gamebot-update.sh
```

Update script only **ff-only** merges `main`. Develop on the Mac; don’t commit on the Pi.
