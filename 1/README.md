# TP-Reseau-B2

- [TP1 : Maîtrise réseau du poste](#tp1--maîtrise-réseau-du-poste)
- [I. Basics](#i-basics)
- [II. Go further](#ii-go-further)
- [III. Le requin](#iii-le-requin)

# I. Basics


☀️ **Carte réseau WiFi**

```
PS C:\Users\guill> ipconfig

   Adresse physique . . . . . . . . . . . : 14-13-33-86-6A-1B
   Adresse IPv4. . . . . . . . . . . . . .: 10.33.76.18
   Masque de sous-réseau. . . . . . . . . : 255.255.240.0

    Netmask:   255.255.240.0 = 20    11111111.11111111.1111 0000.00000000
    Netmask: /20 
```

☀️ **Déso pas déso***

```

- adresse réseau : 10.33.64.0/20
- adresse broadcast : 10.33.79.254/20
- nombre de machines : 4094

```

---

☀️ **Hostname**

  ```
  PS C:\Users\guill> hostname
  Gwuill
   ```
    

---

☀️ **Passerelle du réseau**

```
PS C:\Users\guill> ipconfig

      Passerelle par défaut. . . . . . . . . : 10.33.79.254
PS C:\Users\guill> arp -a
  10.33.79.254          7c-5a-1c-d3-d8-76     dynamique

```
---

☀️ **Serveur DHCP et DNS**

```  
PS C:\Users\guill> ipconfig /all 
    Serveur DHCP . . . . . . . . . . . . . : 10.33.79.254
    Serveurs DNS. . .  . . . . . . . . . . : 8.8.8.8
                                       1.1.1.1
```

---

☀️ **Table de routage**

```
PS C:\Users\guill> route print
Destination réseau    Masque réseau  Adr. passerelle   Adr. interface Métrique
          0.0.0.0          0.0.0.0     10.33.79.254     10.33.76.184     30
```

---

# II. Go further

> Toujours tout en ligne de commande.

---

☀️ **Hosts ?**

```
PS C:\Users\guill> cat c:\Windows\System32\Drivers\etc\hosts
 1.1.1.1 b2.hello.vous
```

```
PS C:\Users\guill> ping b2.hello.vous

Envoi d’une requête 'ping' sur b2.hello.vous [1.1.1.1] avec 32 octets de données :
Réponse de 1.1.1.1 : octets=32 temps=11 ms TTL=57
Réponse de 1.1.1.1 : octets=32 temps=12 ms TTL=57
Réponse de 1.1.1.1 : octets=32 temps=13 ms TTL=57
Réponse de 1.1.1.1 : octets=32 temps=76 ms TTL=57
```

---

☀️ **Go mater une vidéo youtube et déterminer, pendant qu'elle tourne...**

```
PS C:\Users\guill> netstat -n | Select-String "443"

  TCP    192.168.1.28:50384     185.26.182.93:443      ESTABLISHED
  TCP    192.168.1.28:50386     104.18.22.112:443      ESTABLISHED
  TCP    192.168.1.28:50387     104.18.23.112:443      ESTABLISHED
  TCP    192.168.1.28:50388     104.18.22.112:443      ESTABLISHED
  TCP    192.168.1.28:50391     185.26.182.106:443     ESTABLISHED

---
```	

☀️ **Requêtes DNS**

```
PS C:\Users\guill> nslookup www.ynov.com

Nom :    www.ynov.com
Addresses:  104.26.10.233
          104.26.11.233
          172.67.74.226
```

```
PS C:\Users\guill> nslookup 174.43.238.89
Nom :    89.sub-174-43-238.myvzw.com
Address:  174.43.238.89
```

---

☀️ **Hop hop hop**

```
PS C:\Users\guill> tracert -4 www.ynov.com

Détermination de l’itinéraire vers www.ynov.com [104.26.10.233]
avec un maximum de 30 sauts :

  1     4 ms     3 ms     3 ms  lan.home [192.168.1.1]
  2    10 ms     9 ms    23 ms  80.10.239.121
  3    21 ms     8 ms     6 ms  ae119-0.ncbor201.rbci.orange.net [80.10.154.14]
  4     8 ms     9 ms     8 ms  ae42-0.nipoi201.rbci.orange.net [193.252.100.25]
  5    13 ms    10 ms    11 ms  ae40-0.nipoi202.rbci.orange.net [193.252.160.46]
  6    20 ms    23 ms    28 ms  193.252.137.14
  7    47 ms    17 ms    16 ms  bundle-ether305.partr2.saint-denis.opentransit.net [193.251.133.23]
  8    17 ms    36 ms    30 ms  cloudflare-21.gw.opentransit.net [193.251.150.160]
  9    28 ms    25 ms    20 ms  172.71.124.2
 10    34 ms    16 ms    23 ms  104.26.10.233
```

---

☀️ **IP publique**

```
PS C:\Users\guill> nslookup myip.opendns.com resolver1.opendns.com
Serveur :   dns.opendns.com
Address:  208.67.222.222

Réponse ne faisant pas autorité :
Nom :    myip.opendns.com
Address:  195.7.117.146
```
---

☀️ **Scan réseau**

```
PS C:\Users\guill> nmap -sn 192.168.1.0/24
Starting Nmap 7.94 ( https://nmap.org ) at 2023-10-12 21:41 Paris, Madrid (heure dÆÚtÚ)
Nmap done: 256 IP addresses (8 hosts up) scanned in 16.31 seconds
```

# III. Le requin



```markdown
[Lien vers capture ARP](./captures/arp.pcap)
```

---

☀️ **Capture ARP**

Filtre utilisé : `arp`

[Capture ARP](\captures\arp.pcapng)

---

☀️ **Capture DNS**

Filte utilisé : `dns`

[Capture DNS](\captures\dns.pcapng)

```
PS C:\Users\guill> nslookup ynov.com
```	
---

☀️ **Capture TCP**

filtre utilisé : `ip.addr == 213.186.33.87`

[Capture TCP](\captures\tcp.pcapng)


---


