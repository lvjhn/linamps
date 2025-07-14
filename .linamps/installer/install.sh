#
# :: BASE INSTALLER 
# Installs container and DNS nameserver.
# 
set -e

source ./.linamps/lib/@all.sh 

cecho yellow --bold ":: LINAMPS INSTALLER ::"

echo 

source ./.linamps/installer/install-linamps.sh
source ./.linamps/installer/install-nameserver.sh
source ./.linamps/installer/install-container.sh
source run setup
