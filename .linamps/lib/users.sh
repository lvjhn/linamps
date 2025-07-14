
# --- LOG IN AS USER (IN CONTAINER) --- # 
function login_as_user() {
    local _UID=$(incus exec "$CONTAINER_NAME" -- id -u $CONTAINER_USER_USERNAME)

    # --- execute a shell in the container
    incus exec $PROJECT_NAME \
        --user $_UID \
        -- \
        bash -c "
            export HOME=/home/$CONTAINER_USER_USERNAME &&
            cd /home/$CONTAINER_USER_USERNAME && 
            $1
        "
}

# --- GER THE USER ID OF THE DEFAULT USER (IN CONTAINER) --- # 
function container_uid() {
    echo $(incus exec "$CONTAINER_NAME" -- id -u $CONTAINER_USER_USERNAME)
}

# --- GET THE USER ID OF THE ROOT USER (IN CONTAINER) --- # 
function container_root_uid() {
    echo $(incus exec "$CONTAINER_NAME" -- id -u root)
}

# --- CHECK IF USER EXISTS --- # 
function user_exists() {    
    local USERNAME=$1
    
    if id "$USERNAME" &>/dev/null; then
        deluser $USERNAME
    else
        :
    fi
}