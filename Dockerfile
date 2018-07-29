FROM alpine:3.8
MAINTAINER josan <704504886@qq.com>
ENV FILEBEAT_VERSION=5.6.5

COPY run.sh filebeat.yml /tmp/

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
 && cat /tmp/filebeat.yml > /filebeat.yml
 && cp /tmp/run.sh /run.sh
 
 && rm -rf /glibc-2.23-r3.apk \
 && rm -rf /tmp/* \ 
 && apk del curl tar openssl \
 && rm -rf /var/cache/apk/* 
 
 CMD /bin/bash /run.sh
 
 
 
