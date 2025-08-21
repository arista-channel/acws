# Creating VeloCloud Images for EVE-NG/QEMU

This guide provides comprehensive instructions for creating VeloCloud images for EVE-NG/QEMU using OVA and QCOW2/KVM images.

## Overview

This guide focuses on creating an EVE-NG lab from scratch to support VeloCloud test environment. Initially, this guide can be deployed anywhere but has been tested on the internal lab VMware OneCloud and is primarily focused on enabling VMware employees to create their own lab in OneCloud.

### Software Versions Used

- VeloCloud 4.x and 5.x
- VyOS 1.3.x
- EVE-NG EVE-20171007.iso

!!! note "Required Tools"
    These procedures use `guestfish` to mount virtual disk images for temporary access to files for editing, and `openssl` to create password hashes. The EVE-NG server has both of these apps loaded.

## 1. Installing EVE-NG

### 1.1 Installation Guides

There are many different ways to install EVE. I recommend using the ISO distribution, but be aware that internet connectivity is required. If internet is not available during the installation process, then script `/etc/eve-setup.sh` must be executed.

!!! warning "Virtualization Requirement"
    Remember that if you are running EVE-NG on a VM you need to expose hardware-assisted CPU virtualization to guest OS.

### 1.2 Enable EVE-NG

If you are planning to use EVE-NG in OneCloud internal lab and consequently you are planning to attach the primary interface an external IP, then it would be necessary to either have a separate router or configure EVE-NG Linux to route traffic from the EVE lab.

First, enable IP forwarding:

```bash
sysctl -w net.ipv4.ip_forward=1
```

Make the change permanent in `/etc/sysctl.conf`:

```bash
net.ipv4.ip_forward=1
```

Configure a secondary interface on EVE. Example configuration:

```bash
# The primary network interface
iface eth0 inet manual
auto pnet0
iface pnet0 inet static
address 192.168.1.2
netmask 255.255.255.0
gateway 192.168.1.1
dns-nameservers 10.148.20.5
dns-nameservers 10.148.20.6
bridge_ports eth0
bridge_stp off

# Cloud devices
iface eth1 inet manual
auto pnet1
iface pnet1 inet static
address 192.168.100.2
netmask 255.255.255.0
bridge_ports eth1
bridge_stp off
```

Create NAT rule and make it permanent:

```bash
sudo iptables -t nat -A POSTROUTING -o pnet0 -s 192.168.100.0/24 -j MASQUERADE
sudo iptables -t nat -L -n -v
sudo apt-get update
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
```

### 1.3 Public DNS Redirect

If you are using EVE on VMware OneCloud internal lab, then public DNS servers are not available. The following iptables rules will redirect any public Google and OpenDNS queries to the internal servers:

```bash
sudo iptables -t nat -A PREROUTING -p udp -d 8.8.8.8 --dport 53 -j NETMAP --to 10.148.20.5
sudo iptables -t nat -A PREROUTING -p udp -d 8.8.4.4 --dport 53 -j NETMAP --to 10.148.20.6
sudo iptables -t nat -A PREROUTING -p udp -d 208.67.222.220 --dport 53 -j NETMAP --to 10.148.20.6
sudo iptables -t nat -A PREROUTING -p udp -d 208.67.222.222 --dport 53 -j NETMAP --to 10.148.20.6
sudo netfilter-persistent save
```

**VMware Internal DNS servers:**

- US1: 10.148.20.5
- US2: 10.148.20.6
- EMEA1: 10.123.0.71
- EMEA2: 10.123.0.72

### 1.4 Public NTP Redirect

If you are using EVE on VMware OneCloud internal lab, then public NTP servers are not available because port 123 is blocked:

```bash
sudo iptables -t nat -A PREROUTING -p udp --dport 123 -j NETMAP --to 10.128.152.81
sudo netfilter-persistent save
```

**VMware internal NTP servers:**

- time.vmware.com
- time1.vmware.com
- time2.vmware.com

### 1.5 QEMU NIC: e1000 vs virtio-net-pci

When a new node is created on EVE-NG, QEMU NIC type is configurable. We have detected cases where virtio-net-pci gives trouble, at least for nodes connected as client to VeloCloud Edges. In case of unknown networking issues, ensure e1000 is chosen to avoid problems.

### 1.6 VyOS Boot Issues

Sometimes VyOS has issues and does not boot. To recover, you can save the VyOS configuration by accessing the disk directly via guestfish:

```bash
cd /opt/unetlab/tmp/0/<lab-id>/<eve-lab-vyos-node-id>
guestfish --ro -a ./virtioa.qcow2
><fs> run
><fs> list-filesystems
/dev/sda1: ext4
><fs> mount /dev/sda1 /
><fs> cat /boot/1.3-rolling-202008240118/rw/config/config.boot
```

## 2. Install a VyOS Image

### 2.1 Adding VyOS Image to EVE-NG

VyOS is an open-source Linux router quite useful for VeloCloud labs.

**Steps:**

1. Download latest version (1.3.0 as of today)
   - Rolling releases: [https://downloads.vyos.io/?dir=rolling/current/amd64](https://downloads.vyos.io/?dir=rolling/current/amd64)
   - Latest file: [vyos-rolling-latest.iso](https://downloads.vyos.io/rolling/current/amd64/vyos-rolling-latest.iso)

2. Create directory `/opt/unetlab/addons/qemu/vyos-1.3.0-amd64`

3. Copy the VyOS ISO to `/opt/unetlab/addons/qemu/vyos-1.3.0-amd64` with `cdrom.iso` name

4. Create a qcow2 file:
   ```bash
   /opt/qemu/bin/qemu-img create -f qcow2 virtioa.qcow2 10G
   ```

5. Create `/opt/unetlab/html/templates/intel/vyos.yml` file:

```yaml
---
type: qemu
config_script: config_vyos.py
description: VyOS
name: VyOS
cpulimit: 1
url: http://vyos.net/
icon: Router.png
cpu: 1
ram: 512
ethernet: 4
console: telnet
qemu_arch: x86_64
qemu_version: 2.12.0
qemu_nic: virtio-net-pci
qemu_options: -machine type=pc,accel=kvm -serial mon:stdio -nographic -nouser-config -nodefaults -rtc base=utc
...
```

### 2.2 Adding a VyOS VM to Your EVE Lab

You will need a router in most EVE labs to get connectivity to internet, provide routing between different networks, DHCP server, etc.

**Example VyOS Configuration:**

```bash
set interfaces ethernet eth0 address '192.168.100.3/24'
set interfaces ethernet eth1 address '1.1.1.1/24'
set interfaces ethernet eth2 address '2.2.2.1/24'
set interfaces ethernet eth3 address '3.3.3.1/24'
set interfaces ethernet eth4 address '172.16.1.1/24'
set interfaces ethernet eth5 address '172.17.1.1/24'

# NAT configuration
set nat destination rule 200 destination address '192.168.100.3'
set nat destination rule 200 destination port 'https'
set nat destination rule 200 inbound-interface 'eth0'
set nat destination rule 200 protocol 'tcp_udp'
set nat destination rule 200 source address '0.0.0.0/0'
set nat destination rule 200 translation address '1.1.1.2'
set nat destination rule 200 translation port 'https'
set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 translation address 'masquerade'

# Static routing
set protocols static route 0.0.0.0/0 next-hop 192.168.100.2

# DHCP server configuration
set service dhcp-server shared-network-name main1111 authoritative
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 default-router '1.1.1.1'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 dns-server '8.8.8.8'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 dns-server '8.8.4.4'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 lease '86400'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 static-mapping vco ip-address '1.1.1.2'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 static-mapping vco mac-address '50:00:00:02:00:00'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 static-mapping vcg3 ip-address '1.1.1.3'
set service dhcp-server shared-network-name main1111 subnet 1.1.1.0/24 static-mapping vcg3 mac-address '50:00:00:03:00:00'
```

## 3. EVE Preparations for VCO/VCG/VCE

### 3.1 Create Directories for Disk Images

SSH to the EVE-NG machine as root (default password is `eve`):

```bash
ssh root@<eve-ng IP>
```

Create directories for the disk images:

```bash
mkdir /opt/unetlab/addons/qemu/velocloudvco-4.0.0
mkdir /opt/unetlab/addons/qemu/velocloudvcg-4.0.0
mkdir /opt/unetlab/addons/qemu/velocloudvce-4.0.0
```

!!! info "Directory Naming Format"
    Note the format `velocloudvco-4.0.0`. EVE-NG uses the prefix before the `-` as a key for selecting images in the GUI.

### 3.2 Create Template YAML Files

Create template YAML files in `/opt/unetlab/html/templates/intel/` for each component:

**VCO Template (`velocloudvco.yml`):**

```yaml
---
type: qemu
name: vco
cpulimit: 1
icon: vco.png
cpu: 4
ram: 4096
ethernet: 1
console: telnet
shutdown: 1
qemu_arch: x86_64
qemu_nic: e1000
qemu_options: -machine type=pc,accel=kvm -nographic -rtc base=utc
...
```

**VCG Template (`velocloudvcg.yml`):**

```yaml
---
type: qemu
name: velogw
cpulimit: 1
icon: vcg.png
cpu: 2
ram: 4096
ethernet: 2
eth_name:
- Internet
- Handoff
qemu_nic: virtio-net-pci
console: telnet
qemu_arch: x86_64
qemu_options: -machine type=pc-1.0,accel=kvm -cpu host -nographic -rtc base=utc
...
```

**VCE Template (`velocloudvce.yml`):**

```yaml
---
type: qemu
name: veloedge
cpulimit: 1
icon: vce.png
cpu: 2
ram: 2048
ethernet: 6
eth_format: G{1}
qemu_nic: virtio-net-pci
console: telnet
qemu_arch: x86_64
qemu_options: -machine type=pc-1.0,accel=kvm -cpu host -nographic -rtc base=utc
...
```

### 3.3 Create Custom config.php File

Create `/opt/unetlab/html/includes/config.php`:

```php
<?php
$custom_templates = Array(
    'velocloudvco' => 'VeloCloud Orchestrator',
    'velocloudvcg' => 'VeloCloud Gateway',
    'velocloudvce' => 'VeloCloud Edge'
);
?>
```

### 3.4 Image Creation Overview

One issue with using VeloCloud appliance images in EVE-NG is that you don't go through the usual provisioning process. To use the image without cloud-init, you need to use utilities to mount the virtual disk image and edit the `/etc/passwd` file to set a known password for the root user.

## 4. VCO (VeloCloud Orchestrator)

### 4.1 Get Virtual Disk Files

#### 4.1.1 KVM File

Transfer the VCO KVM file to EVE-NG:

```bash
mkdir /opt/unetlab/addons/qemu/velocloudvco-4.0.0
cd /opt/unetlab/addons/qemu/velocloudvco-4.0.0
scp lab@10.10.130.128:/home/lab/velocloud-orchestrator-kvm-4.0.0-R400-20200925-GA-9021c56f76.tar.gz .
```

Extract the tar file:

```bash
tar xvf velocloud-orchestrator-kvm-4.0.0-R400-20200925-GA-9021c56f76.tar.gz
```

Rename the files:

```bash
mv rootfs.qcow2 virtioa.qcow2
mv store.qcow2 virtiob.qcow2
mv store2.qcow2 virtioc.qcow2
mv store3.qcow2 virtiod.qcow2
```

#### 4.1.2 OVA File

If using OVA files, extract and convert to qcow2 format:

```bash
tar xvf velocloud-orchestrator-3.3.1-GA-20191127.ova
qemu-img convert -f vmdk -O qcow2 ./velocloud-orchestrator-disk1.vmdk ./virtioa.qcow2&
qemu-img convert -f vmdk -O qcow2 ./velocloud-orchestrator-disk2.vmdk ./virtiob.qcow2&
qemu-img convert -f vmdk -O qcow2 ./velocloud-orchestrator-disk3.vmdk ./virtioc.qcow2&
```

### 4.2 Cloud Init

VCO uses cloud-init on boot time. Create cloud-init ISO file in the same directory as the qcow2 image.

**Create `meta-data` file:**

```yaml
instance-id: vco501eve
local-hostname: vco501eve
dsmode: local
```

**Create `user-data` file:**

```yaml
#cloud-config
users:
 - default
password: velocloud
chpasswd:
 list: |
  root:velocloud
  vcadmin:velocloud
 expire: False
ssh_pwauth: True
ssh_authorized_keys:
 - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvaaLmF1Krpr2362rOuJ4lkJOj35EJnvK0ffIjjVnaA7oGGyy0TnAF04yUBb19z/MFS9En8shoPdas20SQkN1AlWuH5J5spq6TL/4S1SAVJdU0Xb0AjJQBSwKvuQ6MvrEi9SVuKZ7S7eKEDI8pZtT4GzHqy/b6WqqhFLWGVvxUeLcUxcSklfenE2SRtrYXvTd3kBAVBFB0QIdp4Q3kaMu75gJQ3T2qqVskHLym6Wq/gZt6HfZLEnJ7PLdcdH7hWyXW5APO/aq4Z8YJVYFKTe8n2WSLN5mX+F9J/FBBjW57dVqenLM1ZmkZ26/nbf8uK4L6zZytbff9faWfqffjyAm1
runcmd:
 - 'sudo /opt/vc/bin/cloud_init_ctl -d'
 - 'sudo chage -I -1 -m 0 -M 99999 -E -1 vcadmin'
final_message: "==== Cloud-init completed.. ====="
```

**Create `network-config` file:**

```yaml
---
version: 2
ethernets:
 eth0:
  dhcp4: true
  dhcp4-overrides:
   route-metric: 100
```

**Create ISO file:**

```bash
genisoimage -output cdrom.iso -volid cidata -joliet -rock user-data meta-data network-config
```

### 4.3 Change Password (if Cloud-Init is not used)

Create a password hash using openssl:

```bash
openssl passwd -1 velocloud
```

Open the qcow2 image using guestfish:

```bash
sudo guestfish -w -a ./virtioa.qcow2 -i
```

Edit `/etc/passwd` and replace the `x` with the password hash:

```bash
><fs> vi /etc/passwd
# Change: root:x:0:0:root:/root:/bin/bash
# To: root:$1$QLAUnuzn$a/3uaoM9.Outb3b2PMsI00:0:0:root:/root:/bin/bash
```

Edit SSH configuration:

```bash
><fs> vi /etc/ssh/sshd_config
# Change: PermitRootLogin no
# To: PermitRootLogin yes
# Add: AllowUsers vcadmin root
```

Exit guestfish:

```bash
><fs> exit
```

### 4.4 Boot VCO

Create a new VCO instance in EVE-NG, power it on, and connect to the console.

### 4.5 Disable Cloud-Init

```bash
sudo /opt/vc/bin/cloud_init_ctl -d
# Or manually:
sudo touch /etc/cloud/cloud-init.disabled
```

### 4.6 Configure IP

Edit netplan file in `/etc/netplan/` directory:

```yaml
network:
 ethernets:
  eth0:
   dhcp4: no
   addresses:
    - 1.1.0.5/24
   gateway4: 1.1.0.1
   nameservers:
    addresses: [8.8.8.8,8.8.4.4]
   match:
    macaddress: 50:00:00:0f:00:00
   set-name: eth0
 version: 2
```

### 4.7 Disable Password Expiry

```bash
sudo chage -I -1 -m 0 -M -1 -E -1 root
sudo chage -I -1 -m 0 -M -1 -E -1 vcadmin
```

### 4.8 Change Hostname

Edit `/etc/hostname` and change to `vco`.

Edit `/etc/hosts` file and replace ubuntu with vco:

```bash
127.0.0.1 localhost
127.0.1.1 vco ubuntu
```

Execute command:

```bash
hostname vco
```

### 4.9 Access VCO

Browse to your new VCO:

- URL: `https://<vco ip>/operator`
- User: `super@velocloud.net`
- Password: `vcadm!n`

!!! note "Password Note"
    Note the exclamation mark (!) in the password.

### 4.10 Make VCO UI Available Through EVE Host

To expose VCO UI port through EVE Host external IP:

```bash
sudo iptables -t nat -A PREROUTING -p tcp -d 192.168.1.2 --dport 443 -j DNAT --to-destination 192.168.100.3:443
sudo netfilter-persistent save
```

## 5. VCG (VeloCloud Gateway)

### 5.1 Get Virtual Disk File

Transfer the VCG qcow2 file to EVE-NG:

```bash
mkdir /opt/unetlab/addons/qemu/velocloudvcg-4.0.0
cd /opt/unetlab/addons/qemu/velocloudvcg-4.0.0
scp lab@10.10.130.128:/home/lab/velocloud-vcc-v2-4.0.0-106-R400-20200929-GA-59ea242e7e-kvm.qcow2 ./virtioa.qcow2
```

### 5.2 Cloud Init

Similar to VCO, create cloud-init files for VCG with gateway-specific configurations.

### 5.3-5.7 Configuration Steps

Follow similar steps as VCO for:
- Changing password
- Disabling cloud-init
- Configuring IP
- Disabling password expiry
- Changing hostname

### 5.8 Boot and Activate VCG

Reboot and activate the VCG:

```bash
/opt/vc/bin/activate.py Y3NX-PWNN-M9QB-FZHX -s 172.16.1.2 -i
```

## 6. VCE (VeloCloud Edge)

### 6.1 Get Virtual Disk File

Transfer the VCE qcow2 file to EVE-NG:

```bash
mkdir /opt/unetlab/addons/qemu/velocloudvce-4.0.0
cd /opt/unetlab/addons/qemu/velocloudvce-4.0.0
scp lab@10.10.130.128:/home/lab/edge-VC_KVM_GUEST-x86_64-4.0.0-106-R400-20200929-GA-59ea242e7e-updatable-ext4.qcow2 ./virtioa.qcow2
```

### 6.2 Change Password

Same procedure as VCO, but use this guestfish command:

```bash
guestfish -w -a virtioa.qcow2 -m /dev/sda4
```

### 6.3 Boot VCE

Create a new VCE instance in EVE-NG, power it on, and connect to the console.

### 6.4 Set Edge IP

Set WAN IP from device console:

```bash
/opt/vc/bin/set_wan_config.sh GE3 STATIC 10.0.0.1 255.255.255.0 10.0.0.254
/opt/vc/bin/set_wan_config.sh -a off -5 100 GE3 DHCP
```

### 6.5 Activate Edge

```bash
activate.py AWGT-FSUB-GUZQ-ZJCB -s 172.16.254.251 -i
```

## 7. Non-SD-WAN Sites

### 7.1 Non-SD-WAN Site via Gateway

Configure IPSec on VyOS device for NVS via Gateway:

```bash
set vpn ipsec esp-group ipsec-rtr-esp compression 'disable'
set vpn ipsec esp-group ipsec-rtr-esp lifetime '1800'
set vpn ipsec esp-group ipsec-rtr-esp mode 'tunnel'
set vpn ipsec esp-group ipsec-rtr-esp pfs 'enable'
set vpn ipsec esp-group ipsec-rtr-esp proposal 1 encryption 'aes256'
set vpn ipsec esp-group ipsec-rtr-esp proposal 1 hash 'sha1'

set vpn ipsec ike-group ipsec-rtr-ike ikev2-reauth 'no'
set vpn ipsec ike-group ipsec-rtr-ike key-exchange 'ikev1'
set vpn ipsec ike-group ipsec-rtr-ike lifetime '3600'
set vpn ipsec ike-group ipsec-rtr-ike proposal 1 encryption 'aes256'
set vpn ipsec ike-group ipsec-rtr-ike proposal 1 hash 'sha1'

set vpn ipsec ipsec-interfaces interface 'eth0'
set vpn ipsec site-to-site peer 1.1.1.3 authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer 1.1.1.3 authentication pre-shared-secret 'Velocloud123'
set vpn ipsec site-to-site peer 1.1.1.3 ike-group 'ipsec-rtr-ike'
set vpn ipsec site-to-site peer 1.1.1.3 local-address '1.1.1.10'
set vpn ipsec site-to-site peer 1.1.1.3 tunnel 0 esp-group 'ipsec-rtr-esp'
set vpn ipsec site-to-site peer 1.1.1.3 tunnel 0 local prefix '0.0.0.0/0'
set vpn ipsec site-to-site peer 1.1.1.3 tunnel 0 remote prefix '192.168.0.0/16'
```

### 7.2 Non-SD-WAN Site via Edge

Similar IPSec configuration for NVS via Edge with appropriate peer IP addresses.

### 7.3 Cloud Security Service (CSS)

Configure CSS with specific IKE settings for FQDN authentication.

## 8. Automation of VCO SSL Renewal

### 8.1 Using HTTP Challenge

Install acme.sh and configure for HTTP challenge:

```bash
mkdir /root/acme_home
cd /root/acme_home
curl https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh | sh -s -- --install-online --home /root/acme_home

/root/acme_home/acme.sh --set-default-ca --server letsencrypt

# Create nginx location for challenge
mkdir -p /var/www/letsencrypt/.well-known/acme-challenge/
chmod -R a+rx /var/www/letsencrypt

# Issue certificate
/root/acme_home/acme.sh --issue --keylength 4096 -d vco1112.example.com -w /var/www/letsencrypt --insecure --force

# Install certificate
/root/acme_home/acme.sh --install-cert -d vco1112.example.com \
--key-file /etc/nginx/velocloud/ssl/server.key \
--fullchain-file /etc/nginx/velocloud/ssl/server.crt \
--reloadcmd "service nginx force-reload"
```

### 8.2 Using DNS Challenge

Configure DNS challenge with appropriate DNS provider credentials.

## 9. Optional Tools Installation

### Install Guestfish

On Ubuntu, install required packages:

```bash
sudo apt-get install libguestfs-tools
sudo apt-get install vsftpd
sudo apt-get install openssh-client
sudo apt-get install openssh-server
```

## Troubleshooting Tips

### VCO Database Sync Issues

If VCO replication fails:

```sql
mysql --defaults-file=/etc/mysql/velocloud.cnf
mysql> STOP SLAVE;
mysql> CHANGE MASTER TO Master_Log_File='mysql-bin.000043', master_log_pos=4;
mysql> START SLAVE;
```

### Adding Swap Memory

Add swap memory if RAM resources are limited:

```bash
sudo dd if=/dev/zero of=/store2/swapfile bs=1024M count=10
sudo chmod 600 /store2/swapfile
sudo mkswap /store2/swapfile
sudo swapon /store2/swapfile
sudo echo "/store2/swapfile swap swap defaults 0 0" >> /etc/fstab
```

### VCO Upgrade Space Requirements

For VCO 4.5 to 5.x upgrades:

```bash
lvextend -r -L+2G /dev/mapper/vols-var1
```

## Conclusion

This guide provides comprehensive instructions for setting up VeloCloud components in EVE-NG. Follow the sections relevant to your deployment requirements and refer to the troubleshooting section for common issues.

!!! tip "Best Practices"
    - Always use cloud-init when possible for automated configuration
    - Keep regular backups of your EVE-NG lab configurations
    - Monitor resource usage and adjust VM specifications as needed
    - Use e1000 NIC type if experiencing networking issues with virtio-net-pci