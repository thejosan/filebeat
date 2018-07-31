#!/bin/bash
/bin/sh sed -i "s/yourlogstashurl/$LOGSTASH_URL/g" /filebeat.yml \
/bin/sh sed -i "s/log4_dir/$LOG4_DIR/g" /filebeat.yml \
/bin/sh sed -i "s/nginx_dir/$NGINX_DIR/g" /filebeat.yml \
/bin/sh sed -i "s/pm2_dir/$PM2_DIR/g" /filebeat.yml \
/bin/bash /filebeat -e -c /filebeat.yml -d "publish"
