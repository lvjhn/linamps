#!/bin/bash

source ./.linamps/lib/@all.sh 

include_all_config 

set -e

FILE=/etc/php84/php-fpm.d/www.conf

find_and_replace $FILE "user = nobody" "user = user"
find_and_replace $FILE "group = nobody" "group = user"