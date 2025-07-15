
# --- FIND AND REPLACE (IN FILES) --- # 
function find_and_replace() {
    local HAYSTACK=$1 
    local NEEDLE=$2
    local REPLACE=$3
    $4 sed -i "s/^$NEEDLE/$REPLACE/g" "$HAYSTACK"
}

# --- FIND IN FILE --- # 
function find_in_file() {
    local HAYSTACK=$1
    local NEEDLE=$2
    if grep -q "^$NEEDLE" "$HAYSTACK"; then
        return 0
    else
        return 1
    fi
}

# --- INSERT AFTER A LINE (IN FILE) --- # 
function insert_after_line() {
    local FILE=$1
    local MATCH=$2
    local INSERT=$3
    sed -i "/${MATCH}/a ${INSERT}" "$FILE"
}
