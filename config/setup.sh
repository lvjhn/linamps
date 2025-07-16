source ./.linamps/lib/@all.sh

set -e

include_all_config

echo
cecho bright_yellow --bold "# [CONTAINER] SETTING UP PROJECT"

function install_python() {
    cecho bright_blue --bold "[CONTAINER] Installing [python]..."
    sudo apk add python3=$PYTHON_VERSION py3-pip=$PIP_VERSION
    echo
}

function install_nodejs() {
    cecho bright_blue --bold "[CONTAINER] Installing [nodejs and npm]..."
    sudo apk add nodejs=$NODE_VERSION npm=$NPM_VERSION
    echo
}


function install_php() {
    cecho bright_blue --bold "[CONTAINER] Installing [php]"
    sudo apk add php$PHP_VERSION 
    sudo apk add \
        php$PHP_VERSION-bcmath \
        php$PHP_VERSION-ctype \
        php$PHP_VERSION-curl \
        php$PHP_VERSION-dom \
        php$PHP_VERSION-fileinfo \
        php$PHP_VERSION-mbstring \
        php$PHP_VERSION-mysqli \
        php$PHP_VERSION-openssl \
        php$PHP_VERSION-pdo \
        php$PHP_VERSION-pdo_mysql \
        php$PHP_VERSION-simplexml \
        php$PHP_VERSION-tokenizer \
        php$PHP_VERSION-xml \
        php$PHP_VERSION-xmlwriter \
        php$PHP_VERSION-phar \
        php$PHP_VERSION-session \
        php$PHP_VERSION-json \
        php$PHP_VERSION-mbstring \
        php$PHP_VERSION-opcache \
        php$PHP_VERSION-zlib \
        php$PHP_VERSION-sqlite3 \
        php$PHP_VERSION-pdo_sqlite \
        php$PHP_VERSION-pgsql \
        php$PHP_VERSION-pdo_pgsql \
        php$PHP_VERSION-posix \
        php$PHP_VERSION-exif \
        php$PHP_VERSION-pcntl \
        php$PHP_VERSION-fpm

    sudo rm -rf /usr/bin/php
    sudo ln -s $(which php$PHP_VERSION) /usr/bin/php

    echo
}

function install_composer() {
    cecho bright_blue --bold "[CONTAINER] Installing [composer]"
    echo $HOME
    cd /tmp
    php84 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php84 -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
    php84 composer-setup.php --version=$COMPOSER_VERSION
    php84 -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/bin/composer
    cd -
}

function install_postgresql() {
    cecho bright_blue --bold "[CONTAINER] Installing [postgresql]"
    sudo apk add postgresql$POSTGRESQL_VERSION
    echo
}

function install_adminer() {
    cecho bright_blue --bold "[CONTAINER] Installing [adminer]"

    INSTALL_DIR=/opt/adminer
    DL_LINK=https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php

    sudo mkdir -p $INSTALL_DIR
    sudo wget $DL_LINK -O $INSTALL_DIR/index.php 

    echo 
}

function install_mailpit() {
    cecho bright_blue --bold "[CONTAINER] Installing [mailpit]"

    INSTALL_DIR=/opt/mailpit
    BACK_DIR=$(pwd)

    sudo mkdir -p $INSTALL_DIR
    cd $INSTALL_DIR

    DL_LINK=https://github.com/axllent/mailpit/releases/download/v$MAILPIT_VERSION/mailpit-linux-amd64.tar.gz
    sudo wget $DL_LINK

    sudo tar -zxvf $INSTALL_DIR/*.tar.gz 
    sudo rm -rf $INSTALL_DIR/*.tar.gz

    echo
}


function install_memcached() {
    cecho bright_blue --bold "[CONTAINER] Installing [memcached]"

    sudo apk add memcached=$MEMCACHED_VERSION

    echo
}

function install_nginx() {
    cecho bright_blue --bold "[CONTAINER] Installing [nginx]" 

    sudo apk add nginx=$NGINX_VERSION

    echo 
}

function install_openssh() {
    cecho bright_blue --bold "[CONTAINER] Installing [openssh]" 

    sudo apk add openssh=$OPENSSH_VERSION

    echo
}

function install_openssl() {
    cecho bright_blue --bold "[CONTAINER] Installing [openssl]" 

    sudo apk add openssl=$OPENSSL_VERSION

    echo
}

function install_ufw() {
    cecho bright_blue --bold "[CONTAINER] Installing [ufw]" 

    sudo apk add ufw=$UFW_VERSION

    echo
}

function install_pm2() {
    cecho bright_blue --bold "[CONTAINER] Installing [pm2]" 

    sudo npm install -g pm2

    echo
}


function install_envsubst() {
    cecho bright_blue --bold "[CONTAINER] Installing [envsubst]" 

    apk add gettext-envsubst=$ENVSUBST_VERSION

    echo
}


# --- CONFIGURATION --- # 
function setup_ssh_server() {
  cecho bright_blue --bold "# [CONTAINER] Configuring SSH server..."

  # --- listen at 0.0.0.0 
  find_and_replace /etc/ssh/sshd_config \
    "#ListenAddress 0.0.0.0" \
    "ListenAddress 0.0.0.0" \
    sudo

  # --- generate keys 
  sudo ssh-keygen -A

  echo
}

function setup_postgresql() {
    cecho bright_blue --bold ":: [CONTAINER] Configuring PostgreSQL..."

    sudo rm -rf "$POSTGRESQL_DATA_DIR"
    sudo mkdir -p "$POSTGRESQL_DATA_DIR"
    sudo chown -R postgres:postgres "$POSTGRESQL_DATA_DIR"
    sudo chmod 700 "$POSTGRESQL_DATA_DIR"
    
    cecho yellow "Initializing database..."
    sudo -u postgres initdb -D "$POSTGRESQL_DATA_DIR"
    echo "$POSTGRESQL_DATA_DIR"

    sudo mkdir -p /run/postgresql
    sudo chown postgres:postgres /run/postgresql
    sudo chmod 775 /run/postgresql

    sudo -u postgres pg_ctl \
        -D "$POSTGRESQL_DATA_DIR" \
        -o "-c listen_addresses='${POSTGRESQL_LISTEN_ADDRESSES}'" \
        -w start

    while ! sudo -u postgres pg_isready -q -d postgres; do
        cecho yellow "--- Waiting for PostgreSQL to be ready..."
        sleep 1
    done


sudo -u postgres psql -v ON_ERROR_STOP=1 <<EOF
CREATE USER "${POSTGRESQL_USER}" WITH PASSWORD '${POSTGRESQL_PASSWORD}';
CREATE DATABASE "${POSTGRESQL_USER}" OWNER "${POSTGRESQL_USER}";
CREATE DATABASE "${POSTGRESQL_PROJECT_DB}" OWNER "${POSTGRESQL_USER}";
EOF

    sudo -u postgres pg_ctl -D "$POSTGRESQL_DATA_DIR" -m fast stop

    while sudo -u postgres pg_isready -q -d postgres; do
        cecho yellow "--- Waiting for PostgreSQL to shut down..."
        sleep 1
    done

    echo
}

function setup_nginx() {
  cecho bright_blue --bold "# [CONTAINER] Setting up nginx..."

  cd /home/$CONTAINER_USER_USERNAME/project/

  sudo rm -rf /etc/nginx/nginx.conf 

  sudo cp ./config/sites/nginx.conf /etc/nginx/nginx.conf 
  sudo cp ./config/sites/sites.conf /etc/nginx/http.d/default.conf

  sudo chmod 644 /home/$CONTAINER_USER_USERNAME/project/source
}




# --- INSTALLATION FLOW --- # 
install_python
install_nodejs
install_php 
install_composer
install_adminer
install_mailpit
install_memcached
install_postgresql
install_nginx
install_openssh
install_openssl
install_ufw
install_pm2
install_envsubst

# --- CONFIGURATION FLOW --- # 
setup_postgresql
setup_ssh_server
setup_nginx