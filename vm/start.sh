#!/bin/bash

# Move instalation to volume
if [ -d "/www/server-base" ] && [ ! -d /www/server/panel ]; then
    rm -rf /www/server/*
    yes | cp -rf /www/server-base/* /www/server/
    rm -rf /www/server-base
fi

# Start supervisord and services
/www/server/panel/pyenv/bin/supervisord -n -c /etc/supervisord.conf
