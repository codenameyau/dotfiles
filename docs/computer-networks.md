# Introduction to Computer Networks

#### Jargon and Hardware
- Common Jargons: https://www.howtogeek.com/191139/22-common-network-jargon-terms-explained/
- Routers, Switches, and Network: https://www.howtogeek.com/99001/htg-explains-routers-and-switches/
- Modem vs Router: https://www.howtogeek.com/234233/whats-the-difference-between-a-modem-and-a-router/
- DNS: https://www.howtogeek.com/122845/htg-explains-what-is-dns/
- VPN vs Proxy: https://www.howtogeek.com/247190/whats-the-difference-between-a-vpn-and-a-proxy/

#### Protocols and Packets
- OSI Explanation: https://www.quora.com/What-is-the-simplest-explanation-of-the-OSI-model-involving-real-examples
- OSI Model: http://www.geekshangout.com/the-osi-model/
- TCP vs UDP: https://www.howtogeek.com/190014/htg-explains-what-is-the-difference-between-tcp-and-udp/
- Packet Anatomy: http://www.techrepublic.com/article/exploring-the-anatomy-of-a-data-packet/
- Packet Analyzer: https://en.wikipedia.org/wiki/Packet_analyzer
- Wireshark: https://www.howtogeek.com/104278/how-to-use-wireshark-to-capture-filter-and-inspect-packets/

#### Past, Present, and Future
- [Video: How wireless communication works](https://www.youtube.com/watch?v=yo1e9C9OL9E)
- [Video: Communication from the Stone Age to Modern Age](https://www.youtube.com/watch?v=oxTUC5I22LU)
- [Video: Communication from 1G to 4G & towards the 5G future](https://www.youtube.com/watch?v=2nsEAw_SirQ)
- [Brief history of network communications](http://www.computerhistory.org/timeline/networking-the-web/)

## MAC Addresses
MAC addresses are strings of six 16-bit hexadecimal numbers (`18:cf:5e:5b:19:f6`)
that are used to uniquely identify wireless interfaces on devices that connect to a wireless network
although MAC addresses also be easily falsified in a process called **MAC Spoofing**.
Manufactures and vendors interchangeably call MAC addresses as Device Serial Numbers.

The first six characters of a MAC Address are always assigned to the device's
manufacture by IEEE. You can look this up via:

- [Bash Script](https://github.com/codenameyau/dotfiles/blob/master/bin/mac-lookup)
- http://www.coffer.com/mac_find/?string=samsung
- http://hwaddress.com/

You can lookup your device's wireless interface's MAC address via:

```bash
# Look for "wlan0" for your wireless interface and "eth0" for your wired interface.
ifconfig

# See your machine's hardware specs.
$ sudo lshw
$ sudo lspci -v
```

## Address Resolution Protocol
Machines communicate to each other within an internal network by broadcasting messages
with their MAC addresses. However since wireless communication occurs using IP addresses
instead of MAC addressess, your router must first assign your machine's MAC addresses
to an IP address either via DHCP or Static IP. This process of assigning and
translating MAC addresses to IP addresses is called the Address Resolution Protocol
(ARP) and will be subsequently cached by your router and machine.

#### View the ARP cache
```bash
$ arp
$ arp -a
```

#### View Mac addresses of devices in ARP cache
```bash
# View without host and mac address.
arp | tail -n +3 | awk '{ print $3 }' | xargs -t mac-lookup 2> /dev/null

View with host and mac address.
arp | tail -n +3 | awk '{ print $1, $3 }' | xargs -I{} -- sh -c 'echo {}; mac-lookup {}'
```
