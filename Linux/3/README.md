# TP3 : Linux Hardening

## Sommaire

- [TP3 : Linux Hardening](#tp3--linux-hardening)
  - [Sommaire](#sommaire)
  - [0. Setup](#0-setup)
  - [1. Guides CIS](#1-guides-cis)
  - [2. Conf SSH](#2-conf-ssh)
  - [4. DoT](#4-dot)
  - [5. AIDE](#5-aide)

## 0. Setup

Vous utiliserez une VM Rocky Linux pour dérouler ce TP.

## 1. Guides CIS

CIS est une boîte qui notamment édite des guides de configuration

- assez réputés
- pour sécuriser les installations des OS courants
- notamment les OS Linux

🌞 **Suivre un guide CIS**

- la section 2.1
```bash

```

- les sections 3.1 3.2 et 3.3
- 3.1
  - 3.1.1
  ```bash
  [gwuill@LinuxHard ~]$ grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -
  IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"

  -
  IPv6 is enabled
  [gwuill@LinuxHard ~]$  sudo cat /etc/default/grub
  GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX ipv6.disable=1"
  [gwuill@LinuxHard ~]$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
  Generating grub configuration file ...
  done
  [gwuill@LinuxHard ~]$ sudo grub2-mkconfig -o /boot/efi/EFI/rocky/grub2.cfg
  Generating grub configuration file ...
  done
  [gwuill@LinuxHard ~]$ grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && echo -e "\n -
  IPv6 is enabled\n" || echo -e "\n - IPv6 is not enabled\n"

  - IPv6 is not enabled
  ```
  - 3.1.2
  ```bash
  [gwuill@LinuxHard ~]$ ./wireless.sh

  - Audit Result:
  ** PASS **

  - System has no wireless NICs installed
  ```
  - 3.1.3
  ```bash
  [gwuill@LinuxHard ~]$ ./tipc.sh
  - Audit Result:
  ** PASS **

  - Module "tipc" doesn't exist on the system
  ```
- 3.2 et 3.3
  ```bash
  [gwuill@LinuxHard ~]$ sudo cat /etc/sysctl.conf
  sysctl -w net.ipv4.conf.all.accept_source_route=0
  sysctl -w net.ipv4.conf.default.accept_source_route=0
  sysctl -w net.ipv4.ip_forward=0
  sysctl -w net.ipv4.route.flush=1
  sysctl -w net.ipv4.conf.all.send_redirects=0
  sysctl -w net.ipv4.conf.default.send_redirects=0
  sysctl -w net.ipv4.conf.all.accept_redirects=0
  sysctl -w net.ipv4.conf.default.accept_redirects=0
  sysctl -w net.ipv4.conf.all.secure_redirects=0
  sysctl -w net.ipv4.conf.default.secure_redirects=0
  sysctl -w net.ipv4.conf.all.log_martians=1
  sysctl -w net.ipv4.conf.default.log_martians=1
  sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
  sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
  sysctl -w net.ipv4.conf.all.rp_filter=1
  sysctl -w net.ipv4.conf.default.rp_filter=1
  sysctl -w net.ipv4.tcp_syncookies=1
  ```
- toute la section 5.2 Configure SSH Server
  - 5.2.1
  ```bash
  [gwuill@LinuxHard ~]$ stat -Lc "%n %a %u/%U %g/%G" /etc/ssh/sshd_config
  /etc/ssh/sshd_config 600 0/root 0/root
  ```
  - 5.2.2
  ```bash
  [gwuill@LinuxHard ~]$ sudo ./ssh_private.sh
  - Correctly
  set:

  - File: "/etc/ssh/ssh_host_ecdsa_key" is mode "0600"
  should be mode: "600" or more restrictive
  - File: "/etc/ssh/ssh_host_ecdsa_key" is owned by:
  "" should be owned by "root"
  - File: "/etc/ssh/ssh_host_ecdsa_key" is owned by group
  "" should belong to group "ssh_keys"
  - File: "/etc/ssh/ssh_host_ed25519_key" is mode "0600"
  should be mode: "600" or more restrictive
    - File: "/etc/ssh/ssh_host_ed25519_key" is owned by:
  "" should be owned by "root"
  - File: "/etc/ssh/ssh_host_ed25519_key" is owned by group
  "" should belong to group "ssh_keys"
  - File: "/etc/ssh/ssh_host_rsa_key" is mode "0600"
  should be mode: "600" or more restrictive
    - File: "/etc/ssh/ssh_host_rsa_key" is owned by:
  "" should be owned by "root"
  - File: "/etc/ssh/ssh_host_rsa_key" is owned by group
  "" should belong to group "ssh_keys"
  ```
  - 5.2.3
  ```bash
  [gwuill@LinuxHard ~]$ sudo ./ssh_public.sh
  - Audit Result:

  - Correctly
  set:
  - Public key file: "/etc/ssh/ssh_host_ecdsa_key.pub" is owned
  by: "" should be owned by "root"
  - Public key file: "/etc/ssh/ssh_host_ecdsa_key.pub" is owned
  by group "" should belong to group "root"
  - Public key file: "/etc/ssh/ssh_host_ecdsa_key.pub" is mode
  "0644" should be mode: "644" or more restrictive
  - Public key file: "/etc/ssh/ssh_host_ed25519_key.pub" is owned
  by: "" should be owned by "root"
  - Public key file: "/etc/ssh/ssh_host_ed25519_key.pub" is owned
  by group "" should belong to group "root"
  - Public key file: "/etc/ssh/ssh_host_ed25519_key.pub" is mode
  "0644" should be mode: "644" or more restrictive
  - Public key file: "/etc/ssh/ssh_host_rsa_key.pub" is owned
  by: "" should be owned by "root"
  - Public key file: "/etc/ssh/ssh_host_rsa_key.pub" is owned
  by group "" should belong to group "root"
  - Public key file: "/etc/ssh/ssh_host_rsa_key.pub" is mode
  "0644" should be mode: "644" or more restrictive
  ```
  - 5.2.4
  ```bash
  [gwuill@LinuxHard ssh]$ ls ssh_config.d/
  50-redhat.conf  allowuser.conf  denyuser.conf
  ```
  - 5.2.5
  ```bash
  [gwuill@LinuxHard ssh]$ sudo cat ssh_config.d/log.conf
  LogLevel VERBOSE
  ```
  - 5.2.6
  ```bash
  
- au moins 10 points dans la section 6.1 System File Permissions
- au moins 10 points ailleur sur un truc que vous trouvez utile

> Le but c'est pas de rush mais comprendre ce que vous faites, comprendre ici pourquoi c'est important de vérifier que ces trucs sont activés ou désactivés. Et très bon pour votre culture.

## 2. Conf SSH

🌞 **Chiffrement fort côté serveur**


https://www.ssh.com/academy/ssh/sshd_config

```bash
[gwuill@LinuxHard ssh]$ sudo cat sshd_config.d/ciphers.conf
Ciphers aes128-ctr,aes192-ctr,aes256-ctr

HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521

KexAlgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256

MACs hmac-sha2-256,hmac-sha2-512

```

🌞 **Clés de chiffrement fortes pour le client**

https://www.ssh.com/academy/ssh/keygen

```
PS C:\Users\guill> ssh-keygen -t ecdsa -b 521
```

🌞 **Connectez-vous en SSH à votre VM avec cette paire de clés**

```

```
## 4. DoT

Ca commence à faire quelques années maintenant que plusieurs acteurs poussent pour qu'on fasse du DNS chiffré, et qu'on arrête d'envoyer des requêtes DNS en clair dans tous les sens.

Le Dot est une techno qui va dans ce sens : DoT pour DNS over TLS. On fait nos requêtes DNS dans des tunnels chiffrés avec le protocole TLS.

🌞 **Configurer la machine pour qu'elle fasse du DoT**

```bash
[gwuill@LinuxHard ~]$ sudo cat /etc/systemd/resolved.conf
[Resolve]
FallbackDNS=:
DNS=1.1.1.1
#FallbackDNS=
#Domains=
DNSSEC=yes
DNSOverTLS=yes
#MulticastDNS=no
#LLMNR=resolve
#Cache=yes
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
```

🌞 **Prouvez que les requêtes DNS effectuées par la machine...**

[DoT](/Linux/3/DoT.pcapng)

## 5. AIDE

🌞 **Installer et configurer AIDE**

```bash
[gwuill@LinuxHard systemd]$ sudo cat /etc/aide.conf | tail -n 5
# File very important omg secret don't touch

/etc/ssh/sshd_config CONTENT_EX
/etc/chrony.conf CONTENT_EX
/etc/system/systemd CONTENT_EX
```

🌞 **Scénario de modification**

```bash
[gwuill@LinuxHard systemd]$ sudo aide --check
Start timestamp: 2024-01-12 15:55:03 +0100 (AIDE 0.16)
AIDE found differences between database and filesystem!!

Summary:
  Total number of entries:      37898
  Added entries:                0
  Removed entries:              0
  Changed entries:              1

---------------------------------------------------
Changed entries:
---------------------------------------------------

f   ...    .C... : /etc/ssh/sshd_config
```

🌞 **Timer et service systemd**

```
[gwuill@LinuxHard ~]$ sudo cat /etc/systemd/system/aide.service
[Unit]
Description=super service aide
[Service]
Type=simple
ExecStart=/usr/sbin/aide --check
[gwuill@LinuxHard ~]$ sudo cat /etc/systemd/system/aide.timer
[Timer]
OnBootSec=0
OnUnitActivateSec=600
```
