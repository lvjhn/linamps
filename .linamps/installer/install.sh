#
# :: BASE INSTALLER 
# Installs container and DNS nameserver.
# 
set -e

source ./.linamps/lib/@all.sh 

include_all_config

# cecho yellow --bold ":: LINAMPS INSTALLER ::"

# echo 

# # --- install defaults 
# source ./.linamps/installer/install-linamps.sh
# source ./.linamps/installer/install-container.sh
# source ./.linamps/installer/install-nameserver.sh

# # --- setup project 
# bash utils/fix-permissions.sh
# bash run setup

# # --- install ca certificates 
# source ./.linamps/installer/install-ca-certificates.sh

# # --- sync ~/.bashrc
# incus file push .linamps/.bashrc linamps-project/home/$CONTAINER_USER_USERNAME/.bashrc

# --- update server 
login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash config/sites/server-setup.sh
"

# --- update sites 
bash run update-sites