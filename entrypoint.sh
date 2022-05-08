#!/bin/sh

APP_DIR="/var/www/html"
CONFIG="/var/www/html/.configured"

if [ -f "$CONFIG" ]; then
    echo "Config file already exists!"
else
    cd "$APP_DIR"
	for D in images ; do
		if [ ! -d /data/$D ] ; then
			mkdir /data/$D
		fi

		if [ -d "$APP_DIR/$D" ] ; then
			cp -r $D/ /data/
			rm -rf $D
			ln -s /data/$D .
		fi

		chown www-data:www-data /data/$D
	done
    touch "$CONFIG"
    echo "Creating configuration file!"
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
