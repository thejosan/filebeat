#!/bin/bash
sed -i "s|yourlogstashurl|$LOGSTASH_URL|g" /filebeat.yml 
sed -i "s|yourlog4dir|$LOG4_DIR|g" /filebeat.yml 
sed -i "s|yournginxdir|$NGINX_DIR|g" /filebeat.yml 
sed -i "s|yourpm2dir|$PM2_DIR|g" /filebeat.yml 
/filebeat -e -c /filebeat.yml -d "publish"
