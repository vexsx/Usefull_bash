# Telegram notifier


## 1-Add script (e.g., `telegram_notify.sh`) in a location like `/usr/local/bin/`

### 2-Run `chmod +x /usr/local/bin/telegram_notify.sh` to make the script executable.

**Configure SSH to run the script:**
   - Edit the SSH daemon configuration file by running `sudo nano /etc/ssh/sshd_config`.
   - Add the following line at the end of the file: `ForceCommand /usr/local/bin/telegram_notify.sh`.
   - Save the file and restart the SSH service by running `sudo systemctl restart sshd`.