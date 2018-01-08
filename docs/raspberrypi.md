# Raspberry Pi

## Table of Contents

- [Headless Raspbian Installation](#headless-raspbian-installation)
- [Connect via Ethernet to Computer](#connect-via-ethernet-to-computer)
- [Connect via Wireless Connection](#connect-via-wireless-connection)
- [Add your SSH public key to Pi](#add-your-ssh-public-key-to-pi)
- [SSH to Home Network](#ssh-to-home-network)

### Headless Raspbian Installation

- Recent headless setup: https://howtoraspberrypi.com/how-to-raspberry-pi-headless-setup/
- Create SD card image: https://howtoraspberrypi.com/create-sd-card-raspberry-pi-command-line-linux/
- Connect to WiFi on headless machine: https://howtoraspberrypi.com/connect-wifi-raspberry-pi-3-others/
- Configure wireless connection: https://askubuntu.com/q/406166

It is recommended to follow these steps for Windows with
[Win32DiskImager](https://sourceforge.net/projects/win32diskimager/)
if you do not have a linux system or sufficient experience setting up linux.
Insert your SD card to your computer (not the Raspberry Pi) to get started.

```bash
# Download and unzip the raspbian lite image.
wget https://downloads.raspberrypi.org/raspbian_lite_latest
unzip 2017-11-29-raspbian-stretch-lite.zip

# Insert SD card and find the volume path. It should look like this:
#
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/mmcblk0p1   30G   32K   30G   1% /media/yau/9016-4EF8
#
df -h

# Copy Raspbian image file to SD card.
# Optional: reformat SD card beforehand.
sudo dd bs=1M if=2017-11-29-raspbian-stretch-lite.img of=/dev/mmcblk0
```

Afterwards, visit the `/boot` volume of your SD card and create a
blank file called `ssh` to enable ssh when Raspbian boots.
```bash
cd /media/boot # it may be named differently.
touch ssh
```

### Connect via Ethernet to Computer
- Turn off Raspberry Pi.
- Plug in ethernet from your Pi to your computer.
- In computer, go to Network Connections.
- Find Ethernet connection, click edit.
- Find IPv4 setting and change Method to "Shared to other computers".
- SSH to your Raspberry Pi.

```bash
# The default raspbian password will be "raspberry"
ssh pi@raspberrypi.local
```

### Connect via Wireless Connection
If you don't want to store your password in plaintext you can create a hash.
```bash
wpa_passphrase AndroidAP
```

Create or update `/etc/wpa_supplicant/wpa_supplicant.conf`
```bash
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="Example_WPA_Network"
  key_mgmt=WPA-PSK
  psk="wpa_password_or_hash"
}
```

Then SSH into your Raspberry Pi
```bash
# Find your local network private ip from your computer for wlan0 (ex: 192.168.43.9)
ifconfig

# Discover your device private ip address.
sudo nmap -sn 192.168.43.*
sudo namp -sn 192.168.43.0/24

# Or display the ARP cache if the Pi has sent ARP requests in the network.
arp

# SSH into the Raspberry Pi.
ssh pi@raspberrypi
```

### Add your SSH public key to Pi
```bash
# From your computer, create SSH key. Skip this step if you've done it before.
ssh-keygen

# Copy the public key from your computer to authorized keys in Pi.
cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi 'cat >> .ssh/authorized_keys'

# Next try to SSH to  the Raspberry Pi. You should not be asked for a password.
ssh pi@raspberrypi

# You can also use a different identify file by updating ssh config or specify a private key.
vim ~/.ssh/config
ssh pi@raspberrypi -i ~/.ssh/id_rsa
```

Update `~/.ssh/config`

```
Host pi
  HostName raspberrypi
  User pi
  IdentityFile ~/.ssh/id_rsa
```

This will allow you to SSH into your Pi with this simple command
```
ssh pi
```

### Copying Files
```bash
# Copy from our computer to Raspberry Pi.
scp -r ~/hello-world pi@raspberrypi:~

# Copy from Raspberry Pi to our computer.
scp -r pi@raspberrypi:~/myfile ~
```

### Configure DHCP Static IP
If you want your Raspberry Pi to request a static **private** IP address, then:

```bash
sudo nano /etc/network/interfaces
```

```bash
auto lo
iface lo inet loopback
iface eth0 inet static
address 192.168.1.200  # static ip you want for the pi
netmask 255.255.255.0
gateway 192.168.1.1  # the ip address of the router
```

### SSH to Home Network
- [Setting up SSH server on home network](https://dev.to/zduey/how-to-set-up-an-ssh-server-on-a-home-computer)
- [SSH outside of private network](https://raspberrypi.stackexchange.com/questions/6757/how-to-use-ssh-out-of-home-network)
- [SSH Config file](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/)


#### Enable Port Forwarding and Allow Inbound Traffic
To ssh into your Raspberry Pi from anywhere, you'll need to configure your wireless
router to allow incoming traffic for port 22 (ssh) and enable port forwarding
to route traffic to your Raspberry pi. Although port 22 is the default SSH port,
it's highly recommended that you select an arbitary high numbered port between
`30000~65535` (which I'll refer to as port `XXXXX`) and use that port to forward
traffic to your Pi. These settings can be found in the "Port Forwading" and
"Advanced Filtering" tabs in your router's Firewall settings.

You'll want to add the public key `~/.ssh/id_rsa.pub` of your machine to the
`~/.ssh/authorized_keys` file of your Raspberry Pi. Then on your machine, you'll
want to create or update the `~/.ssh/config` file to include your home network.

```bash
Host home
  Hostname <your-home-ip-address>
  Port <port-XXXXX>
  User pi
  IdentityFile ~/.ssh/id_rsa
```

#### Beef Up Security
Because you're exposing a port from your private network to the internet,
attackers will attempt to bruteforce into your machines so you'll absolutely need to
secure your firewall and **all** your machines that expose an incoming connection.

Make sure that **all** of these bullets are checked.

- Change the hostname of your Raspberry Pi to something other than `raspberrypi`.
- Change the default password of your `pi` user. Create a very long password.
- Setup an SSH key with a passphrase and use it instead of a password to ssh into your Pi.

#### SSH into your Pi and update this file
```
nano /etc/ssh/sshd_config
```

```bash
# Allow SSH incoming traffic from this port.
Port XXXXX # Replace this port.

# Disable password authentication. Make sure to set up SSH keys beforehand.
PasswordAuthentication no

# Disable SSH login via root@raspberrypi
PermitRootLogin No

# Limits the number of concurrent SSH connections.
MaxStartups 3

# Disable X11 GUI forwarding for SSH screen viewers.
X11Forwarding no

# Disable if you do not have a TCP web server running on port 80.
AllowTcpForwarding no
```

#### Restart your SSH daemon
```
/etc/init.d/sshd restart
```

#### Test your connection
If everything is configured correctly, you should now be able to SSH into your
Raspberry Pi from outside of your home network with this command.

```bash
ssh home
```
