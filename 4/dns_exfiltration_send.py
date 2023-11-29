from scapy.all import *

target_ip = sys.argv[1]
payload_data = sys.argv[2].encode('utf-8')

packet = IP(dst=target_ip)/UDP(dport=53)/DNS(rd=1, qd=DNSQR(qname=payload_data))

if len(sys.argv[2]) >= 20:
    print("Le paquet est trop grand !")
    exit(1)
print("Envoi du paquet DNS...")
send(packet)
print("Paquet envoyé !")