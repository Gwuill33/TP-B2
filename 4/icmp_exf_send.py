from scapy.all import *

target_ip = sys.argv[1]
payload_data = sys.argv[2].encode('utf-8')

packet = IP(dst=target_ip)/ICMP(type=8)/Raw(load=payload_data)
send(packet)