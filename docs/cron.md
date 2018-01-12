# Cron

- https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/

## Crontab

```bash
# Edit crontab for current user. Always include newline.
crontab -e

# Edit crontab for system level jobs.
sudo crontab -e
```

Crontab template.
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

Schedule cron in intervals.
```bash
# Run once a minute.
*/1 * * * * /usr/bin/python /home/pi/python-project/test.py

# Run once an hour.
* */1 * * * /usr/bin/python /home/pi/python-project/test.py

```

Programming language cheatsheet.


```
which python
which node
```

```bash
# Node.js
*/30 * * * * /usr/bin/node /home/pi/node-project/test.js

# Python
*/30 * * * * /usr/bin/python /home/pi/python-project/test.py
```

## Operations
Restart cron with the following.
```bash
# Restart the cron daemon.
sudo /etc/init.d/cron restart

# Reload and restart the ccron service.
sudo service cron reload && sudo service cron restart
```

Cron logs can be found in this directory.
```bash
cd /var/log/

# In most linux distros.
less /var/log/cron

# Raspberry pi.
less /var/log/syslog
```
