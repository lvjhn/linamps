source ./.linamps/lib/@all.sh 

include_all_config

cecho bright_green --bold "# [NAMESERVER] Setting up addresses..."

function backup_dnsmasq() {
    cecho yellow "Backing up /etc/dnsmasq.conf"
    if [ ! -f /etc/dnsmasq.conf.base  ]; then
        cp /etc/dnsmasq.conf /etc/dnsmasq.conf.base 
    fi
} 

function setup_dnsmasq() {
    cecho yellow "Setting up dnsmasq..."
    if [ ! -d /mnt/ramdisk ]; then
        mkdir /mnt/ramdisk
        mount -t tmpfs -o size=64M tmpfs /mnt/ramdisk
    fi 

    if [ -f /mnt/ramdisk/hosts ]; then
        echo > /mnt/ramdisk/hosts
    fi 

    cd /mnt/ramdisk
    if [ -f dnsmasq.conf ]; then
        umount -l /etc/dnsmasq.conf
        rm -rf dnsmasq.conf
    fi

    touch dnsmasq.conf
    echo "" > dnsmasq.conf
    cp /etc/dnsmasq.conf.base /mnt/ramdisk/dnsmasq.conf
    cd -

    mount --bind /mnt/ramdisk/dnsmasq.conf /etc/dnsmasq.conf
}

function update_dnmasq() {
    cecho yellow "Updating DNSMasq configuration..."
    cd ./.linamps 
    source env/bin/activate 
    python3 -m ns.update_dnsmasq
    cd -
}

function start_dnsmasq() {
    if pgrep dnsmasq >/dev/null; then 
        killall dnsmasq; 
        while pgrep dnsmasq >/dev/null; do 
            sleep 0.1; 
        done; 
        fi; 
    dnsmasq
}

function flow() {
    backup_dnsmasq
    setup_dnsmasq
    update_dnmasq
    start_dnsmasq
}

flow