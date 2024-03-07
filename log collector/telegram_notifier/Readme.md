# Telegram notifier


## 1-Add script (e.g., `telegram_notify.sh`) in a location like `/usr/local/bin/`

### 2-Run `chmod +x /usr/local/bin/telegram_notify.sh` to make the script executable.

**Configure SSH to run the script:**
   - Edit the SSH daemon configuration file by running `sudo nano /etc/ssh/sshd_config`.
   - Add the following line at the end of the file: `ForceCommand /usr/local/bin/telegram_notify.sh`.
   - Save the file and restart the SSH service by running `sudo systemctl restart sshd`.


## discription 

This Bash script sends a Telegram notification when a user logs in via SSH. It retrieves information such as the user's IP address, timestamp, hostname, SSH port, operating system, current directory, and last login details, and then constructs a message to send via Telegram. The script utilizes functions to extract and format the necessary data before sending the notification.