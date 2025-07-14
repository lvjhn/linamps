
# --- LOG IN AS USER (IN CONTAINER) --- # 
function login_as_user() {
    local _UID=$(incus exec "$PROJECT_NAME" -- id -u $CONTAINER_USER)

    # --- execute a shell in the container
    incus exec $PROJECT_NAME \
        --user $_UID \
        -- \
        bash -c "$1"
}

# --- GER THE USER ID OF THE DEFAULT USER (IN CONTAINER) --- # 
function container_uid() {
    echo $(incus exec "$PROJECT_NAME" -- id -u $CONTAINER_USER)
}

# --- GET THE USER ID OF THE ROOT USER (IN CONTAINER) --- # 
function container_root_uid() {
    echo $(incus exec "$PROJECT_NAME" -- id -u root)
}
