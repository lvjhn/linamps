
# --- INCLUDE VERSIONS CONFIGURATION --- # 
function include_versions_config() {
    if [ -f ./env/versions.env ]; then
        source ./env/versions.env
    fi
}


# --- INCLUDE SERVICES CONFIGURATION --- # 
function include_services_config() {
    if [ -f ./env/services.env ]; then
        source ./env/services.env
    fi
}

# --- INCLUDE PROJECT CONFIGURATION --- # 
function include_project_config() {
    if [ -f ./env/project.env ]; then
        source ./env/project.env
    fi
}

# --- INCLUDE ALL CONFIGURATION --- # 
function include_all_config() {
    include_versions_config
    include_services_config
    include_project_config
}
