
# --- generate CA certificates
login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash .linamps/ssl/generate-ca.sh $2
" 

# --- retrieve CA certificates
cecho yellow "Retrieving CA certificates..."
sudo mkdir -p /var/lib/linamps/ca/public
sudo mkdir -p /var/lib/linamps/ca/private

sudo incus file pull \
    $CONTAINER_NAME/var/lib/ca/public/LINAMPS.crt \
    /var/lib/linamps/ca/public/LINAMPS.crt

sudo incus file pull \
    $CONTAINER_NAME/var/lib/ca/public/LINAMPS.pem \
    /var/lib/linamps/ca/public/LINAMPS.pem

sudo incus file pull \
    $CONTAINER_NAME/var/lib/ca/private/LINAMPS.key \
    /var/lib/linamps/ca/private/LINAMPS.key

sudo chown root:root -R /var/lib/linamps/ca
sudo chmod -R o+rx /var/lib/linamps/ca
sudo chmod -R +t /var/lib/linamps/ca

# --- generate certificates 

login_as_user "
    cd project && 
    echo $CONTAINER_USER_PASSWORD | sudo -S bash .linamps/ssl/generate-certs.sh
" 
