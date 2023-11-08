#!/bin/bash

# Start supervisord and services
/www/server/panel/pyenv/bin/supervisord -n -c /etc/supervisord.conf