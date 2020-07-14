#!/usr/bin/with-contenv bash

mkdir -p /config/app/docs
mkdir -p /config/app/uploads
mkdir -p $APP_PATH/public/docs
mkdir -p $APP_PATH/public/uploads

echo "**** set environment variables ****"
#https://github.com/codimd/server/blob/master/lib/config/environment.js
env-alias "DOMAIN_NAME" "CMD_DOMAIN"
env-alias "ALLOW_GRAVATAR" "CMD_ALLOW_GRAVATAR"
env-alias "ALLOW_ANONYMOUS" "CMD_ALLOW_ANONYMOUS"
env-alias "ALLOW_PDF_EXPORT" "CMD_ALLOW_PDF_EXPORT"
env-alias "ALLOW_LOGIN" "CMD_EMAIL"
env-alias "ALLOW_REGISTER" "CMD_ALLOW_EMAIL_REGISTER"
env-alias "ADD_PORT_URL" "CMD_URL_ADDPORT"
env-alias "LOG_LEVEL" "CMD_LOGLEVEL"

if [ -z "$SESSION_KEY" ]; then
  S_KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1)
  echo $S_KEY > /var/run/s6/container_environment/SESSION_KEY
  env-alias "SESSION_KEY" "CMD_SESSION_SECRET"
fi


if [[ ! -z "$DATABASE_USER" && ! -z "$DATABASE_PASS" && ! -z "$DATABASE_HOST" && ! -z "$DATABASE_NAME" ]]; then
  if [ -z "$DATABASE_PORT" ]; then
    DATABASE_PORT=3306
  fi
  echo "mysql://$DATABASE_USER:$DATABASE_PASS@$DATABASE_HOST:$DATABASE_PORT/$DATABASE_NAME" > /var/run/s6/container_environment/CMD_DB_URL
  echo "+ Environment Variable CMD_DB_URL set"
else
  echo "- Environment Variable CMD_DB_URL not set and required!!!"
  exit 1
fi

echo "**** setup sequelizerc ****"

if [ ! -f "/config/app/.sequelizerc" ]; then
  cp /defaults/.sequelizerc /config/app/.sequelizerc
fi

ln -sf /config/app/.sequelizerc "$APP_PATH/.sequelizerc"


echo "**** setup config.json ****"

if [ ! -f "/config/app/config.json" ]; then
  cp /defaults/config.json /config/app/config.json
fi

ln -sf /config/app/config.json "$APP_PATH/config.json"

# wait 5s for the database
sleep 5

echo "**** chown /config and /app ****"
chown -R abc:abc /config /app/codimd/.sequelizerc /app/codimd/config.json
