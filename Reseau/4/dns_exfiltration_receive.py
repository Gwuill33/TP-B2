from scapy.all import *

def print_message(packet):
    if packet.haslayer(DNSQR):
        dns_question = packet[DNSQR].qname.decode('utf-8', errors='ignore')
        hidden_data = dns_question.split(".")[0]
        print(f"DNS reçu : {hidden_data}")

sniff(filter="udp and host 10.33.67.166 and port 53", prn=print_message, count=25)
