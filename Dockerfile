ARG filebeat_version=6.5.4
FROM docker.elastic.co/beats/filebeat:${filebeat_version}
USER root
RUN usermod -u 2000 filebeat && \
    groupmod -g 2000 filebeat && \
    find /usr/share/filebeat -uid 1000 -exec chown 2000 {} + && \
    find /usr/share/filebeat -gid 1000 -exec chgrp 2000 {} + && \
    mkdir /usr/share/filebeat/conf.d && \
    mkdir /usr/share/filebeat/pki && \
    chown -R 2000:2000 /usr/share/filebeat/conf.d /usr/share/filebeat/pki
USER 2000
