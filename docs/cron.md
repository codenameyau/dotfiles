# Cron

- https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/
- https://askubuntu.com/questions/85558/verify-if-crontab-works

## Crontab

```bash
# Edit crontab for current user. Always include newline.
crontab -e

# Edit crontab for system level jobs.
sudo crontab -e
```

Crontab template:
```bash
# ┌────────── minute (0 - 59)
# │ ┌──────── hour (0 - 23)
# │ │ ┌────── day of month (1 - 31)
# │ │ │ ┌──── month (1 - 12)
# │ │ │ │ ┌── day of week (0 - 6 => Sunday - Saturday, or
# │ │ │ │ │                1 - 7 => Monday - Sunday)
# ↓ ↓ ↓ ↓ ↓
# * * * * * command to be executed
```

Schedule cron in intervals:
```bash
# Run once a minute.
*/1 * * * * /usr/bin/python /home/pi/python-project/test.py

# Run once an hour.
* */1 * * * /usr/bin/python /home/pi/python-project/test.py

```

#### Node with Crontab


```
which node
```

```bash
#!/usr/bin/env node
```

```bash
chmod ugo+x /home/pi/node-project/test.js
```

```bash
*/30 * * * * /home/pi/node-project/test.js
```

## Operations

#### Restart cron daemon:
```bash
sudo /etc/init.d/cron restart
```

#### Enable Cron logs:
By default cron logs are disabled on raspbian. You can enable it
by editing the ryslog configuration file.

```bash
# Uncomment the line that begins with "# cron.*"
sudo nano /etc/rsyslog.conf

# Then Restart rsyslog.
sudo /etc/init.d/rsyslog restart
```

```bash
less /var/log/cron
```
