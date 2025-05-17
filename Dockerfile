ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ARG TARGETARCH

ADD src/install.sh install.sh
RUN sh install.sh && rm install.sh

ENV MARIADB_DATABASE ''
ENV MARIADB_HOST ''
ENV MARIADB_PORT 3306
ENV MARIADB_USER ''
ENV MARIADB_PASSWORD ''
ENV MYSQLDUMP_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID ''
ENV S3_SECRET_ACCESS_KEY ''
ENV S3_BUCKET ''
ENV S3_REGION 'us-west-1'
ENV S3_PATH 'backup'
ENV S3_ENDPOINT ''
ENV S3_S3V4 'no'
ENV SCHEDULE ''
ENV PASSPHRASE ''
ENV BACKUP_KEEP_DAYS ''

ADD src/run.sh run.sh
ADD src/env.sh env.sh
ADD src/backup.sh backup.sh
ADD src/restore.sh restore.sh

CMD ["sh", "run.sh"]
