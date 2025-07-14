# 
# :: CONTAINER INSTALLER 
# Installs linamps in /opt/linamps directory
#
include_all_config 

if [ -f ./.linamps/.env ]; then 
    source ./.linamps/.env
fi 

sudo touch /dev/null 

cecho bright_cyan --bold ":: --- INSTALLING LINAMPS"

function create_linamps_group() {
    cecho bright_green --bold "# [HOST] Creating [linamps] group."

    if getent group linamps > /dev/null 2>&1; then
        cecho yellow "Group [linamps] exist already."
    else 
        cecho yellow "Group [linamps] doesn't exist yet, creating."
        sudo addgroup linamps
    fi 

    echo
}


function create_shared_directory() {
    cecho bright_green --bold "# [HOST] Creating shared directory [$LINAMPS_DIR]."

    _USER=$USER

    if [ ! -d $LINAMPS_DIR ]; then
        cecho yellow "No shared directory yet, creating..."
        sudo mkdir -p $LINAMPS_DIR 
        sudo rm -rf ./.linamps/shared
        sudo ln -s $LINAMPS_DIR ./.linamps/shared
        sudo chown $_USER:linamps -R $LINAMPS_DIR
        sudo chown $_USER:linamps -R ./.linamps/shared
        sudo chmod 777 -R $LINAMPS_DIR
        sudo chmod 777 -R ./.linamps/shared
    else 
        cecho yellow "Shared directory already exists, skipping..."
    fi

    cecho yellow "Adding user to linamps group.."
    sudo adduser $_USER linamps
}

function flow() {
    create_linamps_group
    create_shared_directory
}

flow 

echo
