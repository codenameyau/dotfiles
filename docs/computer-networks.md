# Introduction to Computer Networks

## Network Terminology

Jargon and Hardware
- Common Jargons: https://www.howtogeek.com/191139/22-common-network-jargon-terms-explained/
- Routers, Switches, and Network: https://www.howtogeek.com/99001/htg-explains-routers-and-switches/
- Modem vs Router: https://www.howtogeek.com/234233/whats-the-difference-between-a-modem-and-a-router/

Servers and Tunnels
- DNS: https://www.howtogeek.com/122845/htg-explains-what-is-dns/
- VPN: https://www.howtogeek.com/133680/htg-explains-what-is-a-vpn/
- VPN vs Proxy: https://www.howtogeek.com/247190/whats-the-difference-between-a-vpn-and-a-proxy/

Protocols and Packets
- OSI Explanation: https://www.quora.com/What-is-the-simplest-explanation-of-the-OSI-model-involving-real-examples
- OSI Model: http://www.geekshangout.com/the-osi-model/
- TCP vs UDP: https://www.howtogeek.com/190014/htg-explains-what-is-the-difference-between-tcp-and-udp/
- Packet Anatomy: http://www.techrepublic.com/article/exploring-the-anatomy-of-a-data-packet/
- Packet Analyzer: https://en.wikipedia.org/wiki/Packet_analyzer
- Wireshark: https://www.howtogeek.com/104278/how-to-use-wireshark-to-capture-filter-and-inspect-packets/

Past, Present, and Future
- Inforgraph: http://visual.ly/brief-history-computer-network-technology
- Brief History: http://www.computerhistory.org/timeline/networking-the-web/
- Cellular Networks: https://www.techopedia.com/definition/24962/cellular-network
- Internet of Things: http://www.mckinsey.com/industries/high-tech/our-insights/the-internet-of-things

## MAC Addresses
MAC addresses are strings of six 16-bit hexadecimal numbers (`18:cf:5e:5b:19:f6`)
that are used to uniquely identify wireless interfaces on devices that connect to a wireless network
although MAC addresses also be easily falsified in a process called **MAC Spoofing**.
Manufactures and vendors interchangeably call MAC addresses as Device Serial Numbers.

The first six characters are always assigned to vendors for their hardware, which
you can look up to find the manufacturer for a mac address.

- http://aruljohn.com/mac.pl
- http://www.coffer.com/mac_find/?string=samsung
- https://www.wireshark.org/tools/oui-lookup.html
- http://hwaddress.com/

You can lookup your device's wireless interface's MAC address in the device settings,
router admin (192.168.1.1), or in the terminal.

```bash
# Look for "wlan0" for your wireless interface and "eth0" for your wired interface.
ifconfig

# See your machine's hardware specs.
$ sudo lshw
$ sudo lspci -v
```

## Address Resolution Protocol
Machines communicate to each other within a network by broadcasting messages with their
MAC addresses. However since wireless communication uses IP addresses instead of MAC
addressess, your router will assign your machine's MAC addresses to an IP address either via DHCP or
Static IP. This process of mapping and translating MAC addresses to IP addresses is
called the Address Resolution Protocol (ARP) and will be subsequently cached
by your router and machine.

#### View the ARP cache with this command.
```bash
$ arp
$ arp -a
```

#### View Mac addresses of devices in ARP cache.
```bash
# View without host and mac address.
arp | tail -n +3 | awk '{ print $3 }' | xargs -t mac-lookup 2> /dev/null

View with host and mac address.
arp | tail -n +3 | awk '{ print $1, $3 }' | xargs -I{} -- sh -c 'echo {}; mac-lookup {}'
```
