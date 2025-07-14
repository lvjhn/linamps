#
# :: BASE INSTALLER 
# Installs container and DNS nameserver.
# 
set -e

source ./.linamps/lib/@all.sh 

include_all_config

cecho yellow --bold ":: LINAMPS INSTALLER ::"

echo 

# # --- install defaults 
source ./.linamps/installer/install-linamps.sh
source ./.linamps/installer/install-container.sh
source ./.linamps/installer/install-nameserver.sh

# --- setup project 
bash utils/fix-permissions.sh
bash run setup

source ./.linamps/installer/install-ca-certificates.sh