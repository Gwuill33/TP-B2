from scapy.all import *

def dns_sniffer(pkt):
    if pkt.haslayer(DNSRR):
        for answer in pkt[DNSRR]:
            if answer.type == 1:
                print(f"DNS reçu : {answer.rdata}")


# Filtrer les paquets DNS
sniff(filter="udp port 53", prn=dns_sniffer, count=10)
