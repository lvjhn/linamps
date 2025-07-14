source ./.linamps/lib/@all.sh 

include_all_config

# --- INSTALL DNS MASQ
cecho bright_green --bold "# [NAMESERVER] Installing DNSMasq..."
apk add dnsmasq=2.91-r0

# --- INSTALL MICRO
cecho bright_green --bold "# [NAMESERVER] Installing Micro editor..."
apk add micro=2.0.14-r6

# --- INSTALL PYTHON
cecho bright_green --bold "# [NAMESERVER] Installing Python..."
apk add python3=3.12.11-r0 py3-pip=25.1.1-r0

# --- CREATE VIRTUAL ENVIRONMENT IN NS/ FOLDER 
cecho bright_green --bold "# [NAMESERVER] Creating virtual environment..."
apk add py3-virtualenv
python3 -m venv ./.linamps/env/
source ./.linamps/env/bin/activate
python3 -m pip install python-dotenv

# --- CONFIGURE ADDRESSES
source ./.linamps/ns/setup-addresses.sh