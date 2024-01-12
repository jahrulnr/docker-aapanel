#!/bin/bash

# Move instalation to volume
if [ -d "/www/server-base" ] && [ ! -d /www/server/panel ]; then
    mkdir -p /www/server
    yes | /usr/bin/mv -fv /www/server-base/* /www/server/

    chown -R root:root /www/server
    chown -R www:www /www/wwwroot
fi

if [ -d "/www/server-base" ]; then
    rm -rf /www/server-base
fi

service firewalld start

# Start supervisord and services
/www/server/panel/pyenv/bin/supervisord -n -c /etc/supervisord.conf
