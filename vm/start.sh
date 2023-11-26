#!/bin/bash

# Move init.d from docker to volume
if [ ! -f /etc/init.d/bt ]; then
   yes | cp -rf /tmp/init.d/* /etc/init.d/ 
fi

# Move instalation to volume
if [ -d "/www/server-base" ] && [ ! -d /www/server/panel ]; then
    rm -rf /www/server/*
    yes | cp -rf /www/server-base/* /www/server/

    chown -R root:root /www/server
    chown -R www:www /www/wwwroot
fi

if [ -d "/www/server-base" ]; then
    rm -rf /www/server-base
fi

# Start supervisord and services
/www/server/panel/pyenv/bin/supervisord -n -c /etc/supervisord.conf
