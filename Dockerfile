FROM fabiodcorreia/base-node:1.0.3 as build

ENV APP_VERSION=1.6.0
ENV APP_PATH=/app/codimd
ENV NODE_ENV=development

WORKDIR ${APP_PATH}

RUN apk add --no-cache \
  curl \
  git \
  python3 \
  make

RUN \
  echo "**** download app package ****" && \
    curl -LJO "https://github.com/codimd/server/archive/${APP_VERSION}.tar.gz" && \
  echo "**** extract app package ****" && \
    tar -zxvf "server-${APP_VERSION}.tar.gz" --strip-components 1 && \
  echo "**** clean app package ****" && \
    rm "server-${APP_VERSION}.tar.gz" && \
  echo "**** npm install ****" && \
    npm install &&\
  echo "**** npm build ****" && \
    npm run build &&\
  echo "**** clean non required files ****" && \
    npm uninstall --save prometheus-api-metrics pg pg-hstore passport-bitbucket-oauth2 passport-dropbox-oauth2 passport-facebook passport-github passport-gitlab2 \
      passport-google-oauth20 passport-twitter passport-ldapauth passport-oauth2 passport-saml @passport-next/passport-openid @aws-sdk/client-s3-node azure-storage sqlite3 minio mattermost aws-sdk && \
    rm -rf .gitignore .travis.yml .dockerignore .editorconfig .babelrc .mailmap .sequelizerc.example test docs contribute \
      package-lock.json webpack.prod.js webpack.htmlexport.js webpack.dev.js webpack.common.js .eslintignore .eslintrc.js \
      config.json.example README.md CONTRIBUTING.md AUTHORS node_modules deployments Procfile CHANGELOG.md CODE_OF_CONDUCT.md SECURITY.md&& \
  echo "**** setup completed ****"

FROM fabiodcorreia/base-node:1.0.3

ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="fabiodcorreia"

ENV APP_PATH=/app/codimd

WORKDIR ${APP_PATH}

COPY --chown=abc:abc --from=build /app/codimd .

RUN \
  echo "**** install system packages ****" && \
    apk add --no-cache git python3 make && \
  echo "**** npm install prodution ****" && \
    npm install --production && \
  echo "**** npm cache clean ****" && \
    npm cache clean --force && \
  echo "**** clean tmp ****" && \
    apk del git python3 make && \
    for tar in $(find . -name '*.tar.gz'); do rm -fr $tar; done && \
    rm -rf /tmp/* /var/tmp/*

COPY --chown=abc:abc root/ /
COPY --chown=abc:abc defaults/ /defaults

# Ports
EXPOSE 3000

# Volumes
VOLUME /config
