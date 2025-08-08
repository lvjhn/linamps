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

# # --- setup project 
cecho bright_green --bold "# [HOST] Fixing permissions..."
bash utils/fix-permissions.sh

cecho bright_green --bold "# [HOST] Setting up container..."
bash run setup

# # --- install ca certificates 
echo
cecho bright_green --bold "# [HOST] Installing CA certificates..."
source ./.linamps/installer/install-ca-certificates.sh

# # --- sync ~/.bashrc
echo 
cecho bright_green --bold "# [HOST] Syncing .bashrc..."
incus file push .linamps/.bashrc $CONTAINER_NAME/home/$CONTAINER_USER_USERNAME/.bashrc

# --- update server 
echo 
cecho bright_green --bold "# [HOST] Setting up nginx.."
login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash config/sites/nginx-setup.sh
"

# --- update sites 
echo 
cecho bright_green --bold "# [HOST] Updating sites..."
bash run update-sites

cecho 
echo bright_blue --bold "# DONE."
