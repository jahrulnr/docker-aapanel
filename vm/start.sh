#!/bin/bash

# Move instalation to volume
if [ -d "/www/server-base" ]; then
    rm -r /www/server/*
    yes | cp -rf /www/server-base/* /www/server/
    rm -r /www/server-base
fi

# Start supervisord and services
/www/server/panel/pyenv/bin/supervisord -n -c /etc/supervisord.conf