
# --- CHECK IF INCUS HAS INSTANCE --- # 
function has_instance() {
    local INSTANCE_NAME=$1

    if incus list --format csv --columns n 2>/dev/null | grep -Fxq "$INSTANCE_NAME"; then
        return 0
    else
        return 1
    fi
}

# --- CHECK IF INCUS HAS NETWORK --- # 
function has_network() {
    local NETWORK_NAME=$1 

    if incus network show "$NETWORK_NAME" &>/dev/null; then
        return 0  # true: network exists
    else
        return 1  # false: network does not exist
    fi
}

# --- CHECK IF INCUS INSTANCE IS RUNNING --- # 
function is_instance_running() {
    local STATE=$(incus list "$PROJECT_NAME" --format csv -c s 2>/dev/null)

    if [ "$STATE" = "RUNNING" ]; then
        return 0  # true: instance is running
    else
        return 1  # false: instance is not running or doesn't exist
    fi
}

# --- LIST DOWN INSTANCES TOGETHER WITH THEIR IPS --- # 
function ip_mappings() {
    incus list -c n4 --format csv | awk -F',' '{print $1, $2}'
}