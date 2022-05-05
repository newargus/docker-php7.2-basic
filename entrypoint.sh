#!/bin/sh

APP_DIR="/var/www/html"

if [ -f "$CONFIG" ]; then
    echo "Config file already exists!"
else
    echo "Creating configuration file!"
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
