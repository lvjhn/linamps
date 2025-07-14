source ./.linamps/lib/@all.sh 

include_all_config

cecho bright_yellow --bold "# [CONTAINER] SETTING UP CONTAINER"

echo

# --- INSTALL SUDO --- # 
function install_sudo() {
    cecho bright_green --bold "# [CONTAINER] Installing sudo ($SUDO_VERSION)..."
    
    cecho yellow "Downloading sudo..."
    apk add sudo=$SUDO_VERSION

    cecho yellow "Removing user [$CONTAINER_USER_USERNAME]."
    if [ -d /home/$CONTAINER_USER_USERNAME ]; then
        rm -rf /home/$CONTAINER_USER_USERNAME 
    fi
    if user_exists $USERNAME; then 
        deluser $CONTAINER_USER_USERNAME
    fi 

    cecho yellow "Creating user [$CONTAINER_USER_USERNAME]."
    adduser -D $CONTAINER_USER_USERNAME 

    cecho yellow "Adding [$CONTAINER_USER_USERNAME] to sudoers."
    adduser $CONTAINER_USER_USERNAME wheel 

    cecho yellow "Allowing sudo permissions to wheel group."
    find_and_replace /etc/sudoers \
        "# %wheel ALL=(ALL:ALL) ALL" \
        "%wheel ALL=(ALL:ALL) ALL"

    cecho yellow "Configuring password for [$CONTAINER_USER_USERNAME]."
    echo "$CONTAINER_USER_USERNAME:$CONTAINER_USER_PASSWORD" | chpasswd

    cecho yellow "Configuring password for [root]."
    echo "root:$CONTAINER_ROOT_PASSWORD" | chpasswd

    cecho yellow "Linking project folder."
   
    ln -s /var/lib/project/ /home/$CONTAINER_USER_USERNAME/project

    echo 
}

function install_micro() {
    echo 

    cecho bright_green --bold "# [CONTAINER] Installing micro ($MICRO_VERSION)..."
    apk add micro=$MICRO_VERSION

    echo 
}

function install_nano() {
    echo 

    cecho bright_green --bold "# [CONTAINER] Installing nano ($NANO_VERSION)..."
    apk add nano=$NANO_VERSION

    echo 
}


function install_curl() {
    echo 

    cecho bright_green --bold "# [CONTAINER] Installing curl ($CURL_VERSION)..."
    apk add curl=$CURL_VERSION

    echo 
}


# --- FLOW --- # 
function flow() {
    install_sudo 
    install_micro
    install_nano
    install_curl
}

flow