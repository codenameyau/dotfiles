# Boot Time
In general **Linux Mint** and other debian based distros should boot around 5 to 10  seconds if you have a SSD. **Raspbian** should boot around 10 to 15 seconds. However sometimes, you may notice your boots are taking upwards of 90 seconds.

If your boot consistently takes a long time to boot then it is likely that your bootloader is failing to find the **UUID** of your partition causing it to timeout and mount the default the partition and/or swap space.

### Correcting UUID

Use this script to discover bottlenecks during boot.

```bash
systemd-analyze critical-chain
```

This problem frequently occurs when you add, delete, or reallocate a partition. Below are solutions to fix this issue and speed up your boot time.

- [Linux Mint slow boot times](https://forums.linuxmint.com/viewtopic.php?t=225743)
- [Wrong UUID at boot](https://forums.linuxmint.com/viewtopic.php?t=112685)

You can find the UUID in gparted to make sure they match.

```bash
# These will be the correct UUIDs.
sudo blkid

# Make sure UUIDs match with values above.
cat /etc/fstab
cat /etc/crypttab
```
