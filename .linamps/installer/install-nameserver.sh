#
# :: NAMERSERVER INSTALLER 
# Installs and set up the nameserver in incus.
# 

cecho bright_cyan --bold ":: --- INSTALLING DNS NAMESERVER"

function create_ns_container() {
    cecho bright_green --bold "# Creating nameserver container's for nameserver."

    # --- check if instance is already installed
    if has_instance "linamps-ns"; then
        cecho yellow "Container already exists, skipping."
    else 
        cecho yellow "Creating container [linamps-ns]..."

        # --- create image
        cecho yellow "Downloading image and launching instance..."
        IMAGE=alpine/$ALPINE_VERSION
        echo "Using image $IMAGE."
        incus launch images:$IMAGE "linamps-ns"  

        # --- add storage device
        cecho yellow "Adding storage device..."
        incus config device add "linamps-ns" \
            project disk \
            source=$(pwd) \
            path=/var/lib/linamps/ \
            shift=true
    
        incus config device add "linamps-ns" \
            ramdisk disk \
            source=/mnt/ramdisk/ \
            path=/host/ramdisk/ \
            shift=true

        # --- add network device device
        cecho yellow "Adding network device..."
        incus config device add "linamps-ns" \
            eth0 nic \
            network=$NETWORK_NAME \
            name=eth0 \
            ipv4.address=$NAMESERVER_IP
        echo

        # --- set up container
        setup_ns_container
    fi 
    echo
}

function setup_ns_container() {
    cecho bright_green --bold "# Setting up nameserver container."
    incus exec linamps-ns -- sh -c "apk update"
    incus exec linamps-ns -- sh -c "apk add bash"
    incus exec linamps-ns -- bash -c "
        cd /var/lib/linamps/ && 
        bash ./.linamps/utils/setup-nameserver.sh
    "

}

function flow() {
    create_ns_container
}

flow

echo