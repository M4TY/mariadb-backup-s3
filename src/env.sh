if [ -z "$S3_BUCKET" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "$MARIADB_DATABASE" ]; then
  echo "You need to set the MARIADB_DATABASE environment variable."
  exit 1
fi

if [ -z "$MARIADB_HOST" ]; then
  # https://docs.docker.com/network/links/#environment-variables
  if [ -n "$MARIADB_PORT_3306_TCP_ADDR" ]; then
    MARIADB_HOST=$MARIADB_PORT_3306_TCP_ADDR
    MARIADB_PORT=$MARIADB_PORT_3306_TCP_PORT
  else
    echo "You need to set the MARIADB_HOST environment variable."
    exit 1
  fi
fi

if [ -z "$MARIADB_USER" ]; then
  echo "You need to set the MARIADB_USER environment variable."
  exit 1
fi

if [ -z "$MARIADB_PASSWORD" ]; then
  echo "You need to set the MARIADB_PASSWORD environment variable."
  exit 1
fi

if [ -z "$S3_ENDPOINT" ]; then
  aws_args=""
else
  aws_args="--endpoint-url $S3_ENDPOINT"
fi


if [ -n "$S3_ACCESS_KEY_ID" ]; then
  export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
fi
if [ -n "$S3_SECRET_ACCESS_KEY" ]; then
  export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
fi
export AWS_DEFAULT_REGION=$S3_REGION
export MYSQL_PWD=$MARIADB_PASSWORD
