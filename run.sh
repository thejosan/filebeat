#!/bin/bash
exec filebeat -e -c /filebeat.yml -d "publish"
