# Introduction
This project provides Docker images to periodically back up a MariaDB database to AWS S3, and to restore from the backup as needed.

# Usage
## Backup
```yaml
services:
  mariadb:
    image: mariadb:10.6
    environment:
      MARIADB_ROOT_PASSWORD: rootpassword
      MARIADB_DATABASE: testdb
      MARIADB_USER: user
      MARIADB_PASSWORD: password

  backup:
    image: mariadb-backup-s3:10.6
    environment:
      SCHEDULE: '@weekly'     # optional
      BACKUP_KEEP_DAYS: 7     # optional
      PASSPHRASE: passphrase  # optional
      S3_REGION: region
      S3_ACCESS_KEY_ID: key
      S3_SECRET_ACCESS_KEY: secret
      S3_BUCKET: my-bucket
      S3_PREFIX: backup
      MARIADB_HOST: mariadb
      MARIADB_DATABASE: testdb
      MARIADB_USER: user
      MARIADB_PASSWORD: password
```

- The image is tagged for MariaDB version 10.6.
- The `SCHEDULE` variable determines backup frequency. See go-cron schedules documentation [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules). Omit to run the backup immediately and then exit.
- If `PASSPHRASE` is provided, the backup will be encrypted using GPG.
- Run `docker exec <container name> sh backup.sh` to trigger a backup ad-hoc.
- If `BACKUP_KEEP_DAYS` is set, backups older than this many days will be deleted from S3.
- Set `S3_ENDPOINT` if you're using a non-AWS S3-compatible storage provider.

## Restore
> [!CAUTION]
> DATA LOSS! All database objects will be dropped and re-created.

### ... from latest backup
```sh
docker exec <container name> sh restore.sh
```

> [!NOTE]
> If your bucket has more than a 1000 files, the latest may not be restored -- only one S3 `ls` command is used

### ... from specific backup
```sh
docker exec <container name> sh restore.sh <timestamp>
```

# Development
## Build the image locally
```sh
DOCKER_BUILDKIT=1 docker build --build-arg ALPINE_VERSION=3.16 .
```
## Run a simple test environment with Docker Compose
```sh
cp template.env .env
# fill out your secrets/params in .env
docker compose up -d
```

# Acknowledgements
This project is adapted from a PostgreSQL backup solution to work with MariaDB 10.6.

## Features
  - dedicated repository
  - automated builds
  - backup and restore with one image
  - support for MariaDB 10.6
  - support encrypted (password-protected) backups
  - support for restoring from a specific backup by timestamp
  - support for auto-removal of old backups
