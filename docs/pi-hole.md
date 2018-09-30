# Pi-Hole

- [Simplest Installation Guide](https://www.stakebox.org/blogs/learn/getting-started-with-pi-hole-your-network-wide-ad-blocker)
- [GitHub and Installation](https://github.com/pi-hole/pi-hole#curl--ssl-httpsinstallpi-holenet--bash)
- [The Big Blocklist Collection](https://firebog.net/)
- [Adding Additional Blocklists](https://discourse.pi-hole.net/t/how-do-i-add-additional-block-lists-to-pi-hole/259)

### Update address reservation
In your router settings -> Advanced Settings -> LAN Setup,
assign a static IP address reservation for your pi-hole.

![router address reservation](https://user-images.githubusercontent.com/3826772/46258639-246f0d00-c49c-11e8-88c0-3ca77e0dbb37.png)


### Configure router DNS settings

Update the primary DNS server. **Make sure that the pi-hole is the only DNS
server running** otherwise your router will resolve any DNS conflicts by
visiting another DNS server. Your router should reboot after this step.


#### Bad: has backup secondary and tertiary DNS servers
![router dns settings](https://user-images.githubusercontent.com/3826772/46082360-e789da00-c16c-11e8-8f80-db7ae0c9f6c8.png)

#### Good: secondary and tertiary DNS servers are empty
![router dns settings](https://user-images.githubusercontent.com/3826772/46258622-cfcb9200-c49b-11e8-8d08-b4b966895109.png)

### Reconfigure Pi-hole
Lastly after you've updated your router setting, you must reconfigure your
pi-hole by running this command.

```
pihole -r
```

After this step is complete, most DNS queries to advertising servers
will be blocked thereby speeding up your browsing experience and lowering your
internet bandwidth usage. That's all!
