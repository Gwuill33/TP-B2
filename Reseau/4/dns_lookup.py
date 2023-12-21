from scapy.all import *
import sys

dns_req = Ether(src='14:13:33:86:6a:1b')/IP(src='10.33.76.184', dst='8.8.8.8')/ UDP(dport=53)/ DNS(rd=1, qd=DNSQR(qname=sys.argv[1]))
ans, unans = srp(dns_req, timeout=2)

print(f"""DNS reçu ! Adresse IP : {ans[0][1][DNS].an.rdata}""")