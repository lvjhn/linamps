import os 
from dotenv import load_dotenv

load_dotenv("/var/lib/linamps/.linamps/.env")

dne = os.getenv("DOMAIN_NAME_EXTENSION")

def load_ip_mappings():
    data = open("/host/ramdisk/ip_mappings", "r").read().strip() 

    lines = data.split("\n")
    token_lines = [line.split(" ") for line in lines]
     
    mappings = [
        { "hostname" : token_line[0], "ip" : token_line[1] } 
        for token_line in token_lines
    ]

    return mappings

def update_configuration(mappings):

    conf = open("/etc/dnsmasq.conf", "w")
    conf.truncate(0)

    # --- write base configuration
    base  = open("/etc/dnsmasq.conf.base", "r").read()
    conf.write(base)

    conf.write("\n")
    conf.write("# --- ADDRESSES --- #\n")

    # --- write mappings 
    for mapping in mappings:
        hostname = mapping['hostname']
        ip = mapping['ip']
        conf.write(f"address=/{hostname}{dne}/{ip}\n")
        conf.write(f"address=/.{hostname}{dne}/{ip}\n")

mappings = load_ip_mappings()
update_configuration(mappings)
