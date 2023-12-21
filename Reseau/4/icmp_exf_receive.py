from scapy.all import *

def print_message(packet):
        if packet[ICMP].type == 8:
                return
        else :
            message = packet[Raw].load.decode('utf-8', errors='ignore')
            print(f"ICMP reçu ! MESSAGE : {message}")

sniff(filter="icmp", prn=print_message, count=25)
