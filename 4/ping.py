from scapy.all import *

ping = ICMP(type=8)
packet = IP(src="10.33.76.184", dst="10.33.74.56")
frame= Ether(src='14:13:33:86:6a:1b', dst='c0:e4:34:a8:f2:d5')
final_frame = frame/packet/ping
ans, unans = srp(final_frame, timeout=2)
print(f"Pong reçu : {ans[0]}")