# Pi-Hole

- [Simplest Installation Guide](https://www.stakebox.org/blogs/learn/getting-started-with-pi-hole-your-network-wide-ad-blocker)
- [GitHub and Installation](https://github.com/pi-hole/pi-hole#curl--ssl-httpsinstallpi-holenet--bash)
- [The Big Blocklist Collection](https://firebog.net/)
- [Adding Additional Blocklists](https://discourse.pi-hole.net/t/how-do-i-add-additional-block-lists-to-pi-hole/259)

### Update address reservation
In your router settings -> Advanced Settings -> LAN Setup,
assign a static IP address reservation for your pi-hole.

![router address reservation](https://user-images.githubusercontent.com/3826772/46258245-14076400-c495-11e8-8250-9321ad449660.png)


### Configure router DNS settings

Update the primary DNS server. Make sure that the pi-hole is the only DNS
server running otherwise your router will resolve any DNS conflicts by
visiting another DNS server.


#### Bad: has secondary and tertiary DNS servers
![router dns settings](https://user-images.githubusercontent.com/3826772/46082360-e789da00-c16c-11e8-8f80-db7ae0c9f6c8.png)

#### Good: secondary and tertiary DNS servers are empty
![router dns settings](https://user-images.githubusercontent.com/3826772/46258514-1ae4a580-c49a-11e8-89db-3eed2dc6dc69.png)

### Reconfigure Pi-hole
Lastly after you've updated your router setting, you must reconfigure your
pi-hole by running this command.

```
pihole -r
```

That's all! After this step is complete, most DNS queries to advertising servers
will be blocked thereby speeding up your browsing experience and lowering your
internet bandwidth usage.
