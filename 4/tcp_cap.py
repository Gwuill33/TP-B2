from scapy.all import *

def print_tcp(packet):
    print(f"""TCP SYN ACK reçu !
- Adresse IP src :{packet[IP].src}
- Adresse IP dst : {packet[IP].dst}
- Port TCP src : {packet[TCP].sport}
- Port TCP dst : {packet[TCP].dport}
""")

sniff(filter="tcp", prn=print_tcp, count=1)