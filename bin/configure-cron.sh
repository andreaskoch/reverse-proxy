#!/bin/bash

# reload nginx config
crontab -l > cron.bak
echo "* * * * * root /usr/sbin/nginx -s reload" >> cron.bak
crontab cron.bak
rm cron.bak