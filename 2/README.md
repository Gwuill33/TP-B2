# TP2 : Environnement virtuel

# I. Topologie réseau

## Compte-rendu

☀️ Sur **`node1.lan1.tp2`**

```
[gwuill@node1-lan1-tp2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c4:92:cf brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.11/24 brd 10.1.1.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec4:92cf/64 scope link
       valid_lft forever preferred_lft forever
```

```
[gwuill@node1-lan1-tp2 ~]$ ip route show
10.1.1.0/24 dev enp0s3 proto kernel scope link src 10.1.1.11 metric 100
10.1.2.0/24 via 10.1.1.254 dev enp0s3
```

```
[gwuill@node1-lan1-tp2 ~]$ ping 10.1.2.12
PING 10.1.2.12 (10.1.2.12) 56(84) bytes of data.
64 bytes from 10.1.2.12: icmp_seq=1 ttl=63 time=1.80 ms
64 bytes from 10.1.2.12: icmp_seq=2 ttl=63 time=2.30 ms
```

```
[gwuill@node1-lan1-tp2 ~]$ traceroute 10.1.2.12
traceroute to 10.1.2.12 (10.1.2.12), 30 hops max, 60 byte packets
 1  10.1.1.254 (10.1.1.254)  10.094 ms  9.523 ms  8.172 ms
 2  10.1.2.12 (10.1.2.12)  7.561 ms !X  6.593 ms !X  6.208 ms !X
```

# II. Interlude accès internet

![No internet](./img/no%20internet.jpg)

**On va donner accès internet à tout le monde.** Le routeur aura un accès internet, et permettra à tout le monde d'y accéder : il sera la passerelle par défaut des membres du LAN1 et des membres du LAN2.

**Ajoutez une carte NAT au routeur pour qu'il ait un accès internet.**

☀️ **Sur `router.tp2`**

```
[gwuill@router-tp2 ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=56 time=12.9 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=56 time=13.5 ms
```

```
[gwuill@router-tp2 ~]$ ping ynov.com
PING ynov.com (104.26.11.233) 56(84) bytes of data.
64 bytes from 104.26.11.233 (104.26.11.233): icmp_seq=1 ttl=56 time=13.4 ms
64 bytes from 104.26.11.233 (104.26.11.233): icmp_seq=2 ttl=56 time=19.8 ms
```


☀️ **Accès internet LAN1 et LAN2**

```
[gwuill@node2-lan1-tp2 ~]$ ip r s
default via 10.1.1.254 dev enp0s3
10.1.1.0/24 dev enp0s3 proto kernel scope link src 10.1.1.12 metric 100
10.1.2.0/24 via 10.1.1.254 dev enp0s3 proto static metric 100
```

```
[gwuill@node2-lan1-tp2 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
NAME=enp0s3
DEVICE=enp0s3

BOOTPROTO=static
ONBOOT=yes

IPADDR=10.1.1.12
NETMASK=255.255.255.0

DNS1=1.1.1.1
```

```
[gwuill@node2-lan1-tp2 ~]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=55 time=32.7 ms
```

```
[gwuill@node2-lan1-tp2 ~]$ ping ynov.com
PING ynov.com (104.26.11.233) 56(84) bytes of data.
64 bytes from 104.26.11.233 (104.26.11.233): icmp_seq=1 ttl=55 time=14.5 ms
64 bytes from 104.26.11.233 (104.26.11.233): icmp_seq=2 ttl=55 time=14.9 ms
```

# III. Services réseau

## 1. DHCP

☀️ **Sur `dhcp.lan1.tp2`**

```
[gwuill@dhcp-lan1-tp2 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s3

IPADDR=10.1.1.253
NETMASK=255.255.255.0

DNS1=1.1.1.1
```
```
[gwuill@dhcp-lan1-tp2 ~]$ sudo dnf -y install dhcp-server

[gwuill@dhcp-lan1-tp2 ~]$ sudo cat /etc/dhcp/dhcpd.conf
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
# specify DNS server's hostname or IP address
option domain-name-servers     1.1.1.1;
# default lease time
default-lease-time 600;
# max lease time
max-lease-time 7200;
# this DHCP server to be declared valid
authoritative;
# specify network address and subnetmask
subnet 10.1.1.0 netmask 255.255.255.0 {
    # specify the range of lease IP address
    range dynamic-bootp 10.1.1.100 10.1.1.200;
    # specify broadcast address
    option broadcast-address 10.0.0.255;
    # specify gateway
    option routers 10.1.1.254;
}

[gwuill@dhcp-lan1-tp2 ~]$ sudo systemctl status dhcpd
● dhcpd.service - DHCPv4 Server Daemon
     Loaded: loaded (/usr/lib/systemd/system/dhcpd.service; enabled; preset: disabled)
     Active: active (running) since Thu 2023-10-19 15:18:10 CEST; 9s ago
```	



☀️ **Sur `node1.lan1.tp2`**

```
[gwuill@node1-lan1-tp2 ~]$ sudo cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
NAME=enp0s3
DEVICE=enp0s3

BOOTPROTO=dhcp
ONBOOT=yes
```

```
[gwuill@dhcp-lan1-tp2 ~]$ cat /var/lib/dhcpd/dhcpd.leases
lease 10.1.1.100 {
  starts 4 2023/10/19 13:25:40;
  ends 4 2023/10/19 13:35:40;
  cltt 4 2023/10/19 13:25:40;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 08:00:27:c4:92:cf;
  uid "\001\010\000'\304\222\317";
  client-hostname "node1-lan1-tp2";
}
```

```
[gwuill@node1-lan1-tp2 ~]$ ip r s
default via 10.1.1.254 dev enp0s3 proto dhcp src 10.1.1.100 metric 100
10.1.1.0/24 dev enp0s3 proto kernel scope link src 10.1.1.100 metric 100
```

```
[gwuill@dhcp-lan1-tp2 ~]$ ping 10.1.2.12
PING 10.1.2.12 (10.1.2.12) 56(84) bytes of data.
64 bytes from 10.1.2.12: icmp_seq=1 ttl=63 time=2.61 ms
64 bytes from 10.1.2.12: icmp_seq=2 ttl=63 time=2.15 ms
```

## 2. Web web web

☀️ **Sur `web.lan2.tp2`**

```
[gwuill@web-lan2-tp2 ~]$ sudo dnf install nginx
```

```
[gwuill@web-lan2-tp2 ~]$ sudo cat /etc/nginx/conf.d/site_nul.conf
    server {
        listen       80;
        root         /var/www/site_nul/;
        }
```
```
[gwuill@web-lan2-tp2 ~]$ sudo ls -al /var/www/
drwxr-xr-x.  2 nginx nginx   24 Oct 19 15:48 site_nul
```
```
[gwuill@web-lan2-tp2 ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Thu 2023-10-19 16:12:15 CEST; 4s ago
```

```
[gwuill@web-lan2-tp2 ~]$ sudo firewall-cmd --port-add=80/tcp --permanent
succes
```

```
[gwuill@web-lan2-tp2 ~]$ ss -alnpt | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*
```
```
[gwuill@web-lan2-tp2 ~]$ sudo firewall-cmd --list-all
  ports: 80/tcp
```

☀️ **Sur `node1.lan1.tp2`**

```	
[gwuill@node1-lan1-tp2 ~]$ cat /etc/hosts
10.1.2.12   web.lan2.tp2
[gwuill@node1-lan1-tp2 ~]$ curl web.lan2.tp2
<H1>Franchements les chats...</H1>
```

![That's all folks](./img/cat.jpg)
