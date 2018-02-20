# Boot Time
In general **Linux Mint** and other debian based distros should boot around 
5 to 10  seconds if you have a SSD. **Raspbian** should boot around 
10 to 15 seconds.

Use this script to discover bottlenecks during boot.

```bash
systemd-analyze critical-chain
```

### Correcting UUID

If your boot consistently takes over 90 seconds (1 min 30 seconds) then it
is likely that the **UUID** of your partition has changed which causes the boot
to fail to mount the filesystem and/or swap space until **timeout**.

This frequently occurs when you add a new partition or change the existing
partition size of a file system or swap space.

- [Linux Mint slow boot times](https://forums.linuxmint.com/viewtopic.php?t=225743)
- [Wrong UUID at boot](https://forums.linuxmint.com/viewtopic.php?t=112685)

You can find the UUID in gparted or blkid and to make sure they match.

```bash
# These will be the correct UUIDs.
sudo blkid

# Make sure UUIDs match with values above.
cat /etc/fstab
cat /etc/crypttab
``
`
