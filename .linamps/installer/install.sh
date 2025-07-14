#
# :: BASE INSTALLER 
# Installs container and DNS nameserver.
# 

source ./.linamps/lib/@all.sh 

cecho yellow --bold ":: LINAMPS INSTALLER ::"

echo 

source ./.linamps/installer/install-linamps.sh
source ./.linamps/installer/install-container.sh
source ./.linamps/installer/install-nameserver.sh