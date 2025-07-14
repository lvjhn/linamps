# 
# :: CONTAINER INSTALLER 
# Installs and sets up the container in incus.
#

include_all_config

cecho bright_cyan --bold ":: --- INSTALLING CONTAINER"

function initialize_container() {
    cecho bright_green --bold "# [HOST] Initializing container..."

    # --- remove existing container
    if has_instance $CONTAINER_NAME; then 
        cecho yellow "Existing container detected, deleting..."
        
        if is_instance_running $CONTAINER_NAME; then
            cecho yellow "Instance is currently running, stopping..."
            incus stop $CONTAINER_NAME --force
        fi 
        
        incus delete $CONTAINER_NAME
    fi 

    # --- download and launch container
    cecho yellow "Downloading image and launching instance..."
    IMAGE=alpine/$ALPINE_VERSION
    echo "Using image $IMAGE."
    incus launch images:$IMAGE $CONTAINER_NAME  

    echo 
}

function setup_storage() {
    cecho bright_green --bold "# [HOST] Setting up container storage..."

    sudo mkdir -p /mnt/ramdisk/
    sudo touch /mnt/ramdisk/ip_mappings
    
    incus config device add $CONTAINER_NAME \
        project disk \
        source=$(pwd) \
        path=/var/lib/project/ \
        shift=true
    
    incus config device add $CONTAINER_NAME \
        ramdisk disk \
        source=/mnt/ramdisk/ \
        path=/host/ramdisk/ \
        shift=true

    echo
}

function setup_network() {
    cecho bright_green --bold "# [HOST] Setting up container network..."

    if ! has_network $NETWORK_NAME ; then
        cecho yellow "Creating network bridge: $NETWORK_NAME."
        incus network create "$NETWORK_NAME"
        incus network set "$NETWORK_NAME" ipv4.address=$NETWORK_IP/24
        incus network set "$NETWORK_NAME" ipv4.nat=true
        incus network set "$NETWORK_NAME" ipv6.address=none
    else
        cecho yellow "Network bridge $NETWORK_NAME already exists."
    fi

    cecho yellow "Attaching network $NETWORK_NAME to container."
    incus config device add $CONTAINER_NAME eth0 nic network=$NETWORK_NAME name=eth0
    
    echo
}

function start_container() {
    cecho bright_green --bold "# [HOST] Starting container..."

    if is_instance_running $CONTAINER_NAME; then 
        cecho yellow "Container is already running, skipping."
    else 
        cecho yellow "Container is not yet running, starting."
        incus start $CONTAINER_NAME
    fi

    echo
}

function install_bash() {
    cecho bright_green --bold "# [HOST] Installing bash..." 
    incus exec $CONTAINER_NAME -- sh -c "apk update"
    incus exec $CONTAINER_NAME -- sh -c "apk add bash"
    echo
}


function copy_context_script() {
    cecho bright_green --bold "# [HOST] Linking context script..." 
    incus exec $CONTAINER_NAME -- \
        cp  /var/lib/project/.linamps/misc/linamps-context \
            /usr/bin/linamps-context
     incus exec $CONTAINER_NAME -- \
        chmod +x /usr/bin/linamps-context
     
}

function execute_setup_script() {
    cecho bright_green --bold "# [HOST] Executing setup script..." 
    incus exec $CONTAINER_NAME -- bash -c "
        cd /var/lib/project && 
        bash .linamps/utils/setup-container.sh
    "
    echo
}

function flow() {
    initialize_container
    setup_storage
    setup_network
    start_container
    install_bash
    copy_context_script
    execute_setup_script
}

flow
echo
