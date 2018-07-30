FROM alpine:3.8
MAINTAINER josan <704504886@qq.com>
ENV FILEBEAT_VERSION=5.6.5

COPY run.sh filebeat.yml /tmp/
ENV LOGSTASH_URL=192.168.1.1:10057

RUN set -x \
 && apk add --update bash curl tar openssl \ 
 && apk --no-cache add ca-certificates \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk \
 && apk add glibc-2.23-r3.apk \
 
 && curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
 && tar xzvf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -C / --strip-components=1 \
 && rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
 && ln -s /filebeat /bin/filebeat \
 && mkdir -p /applog \
 && mkdir -p /applog/pm2 \
 && mkdir -p /applog/nginx \
 && mkdir -p /applog/javalog4 \
 && cp /tmp/run.sh /run.sh \
 && cat >/filebeat.yml<<EOF
filebeat.prospectors:
- input_type: log
  paths:
    - /applog/javalog4/app.log
  document_type: log4
  multiline.pattern: ^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]
  multiline.negate: true
  multiline.match: after
  index: log4
  
- input_type: log
  paths:
    - /applog/nginx/access.log
  document_type: nginx
  
- input_type: log
  paths:
    - /applog/h5/app-error-0.log
  document_type: h5
  multiline.pattern: ^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]
  multiline.negate: true
  multiline.match: after
  index: h5
  
output.logstash:
  hosts: ["$LOGSTASH_URL"]
EOF \

 
 && rm -rf /glibc-2.23-r3.apk \
 && rm -rf /tmp/* \ 
 && apk del curl tar openssl \
 && rm -rf /var/cache/apk/* 
 
 CMD /bin/bash /run.sh
 
 
 
