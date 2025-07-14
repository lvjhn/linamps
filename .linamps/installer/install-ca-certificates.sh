
# --- generate CA certificates
login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash .linamps/ssl/generate-ca.sh
" 

# --- retrieve CA certificates
cecho yellow "Retrieving CA certificates..."
sudo mkdir -p /var/lib/linamps/ca/public
sudo mkdir -p /var/lib/linamps/ca/private

sudo incus file pull \
    $CONTAINER_NAME/tmp/ca/public/linamps.crt \
    /var/lib/linamps/ca/public/linamps.crt

sudo incus file pull \
    $CONTAINER_NAME/tmp/ca/private/linamps.key \
    /var/lib/linamps/ca/private/linamps.key

sudo chown root:root -R /var/lib/linamps/ca
sudo chmod -R o+rx /var/lib/linamps/ca
sudo chmod -R +t /var/lib/linamps/ca

# --- generate certificates 
login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash .linamps/ssl/generate-certs.sh
" 
