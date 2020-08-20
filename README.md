# Docker CodiMD Image

![Maintenance](https://img.shields.io/maintenance/no/2020?style=plastic) [![Drone Status](https://img.shields.io/drone/build/fabiodcorreia/docker-codimd?style=plastic)](https://cloud.drone.io/fabiodcorreia/docker-codimd) [![Latest Release](https://img.shields.io/github/v/release/fabiodcorreia/docker-codimd?style=plastic)](https://github.com/fabiodcorreia/docker-codimd/releases/latest) [![GitHub Licence](https://img.shields.io/github/license/fabiodcorreia/docker-codimd?style=plastic)](https://github.com/fabiodcorreia/docker-codimd/blob/master/LICENSE)


![MicroBadger Layers](https://img.shields.io/microbadger/layers/fabiodcorreia/codimd?style=plastic) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/fabiodcorreia/codimd?style=plastic)](https://hub.docker.com/r/fabiodcorreia/codimd) [![Docker Pulls](https://img.shields.io/docker/pulls/fabiodcorreia/codimd?style=plastic)](https://hub.docker.com/r/fabiodcorreia/codimd) ![Docker Image Version (latest semver)](https://img.shields.io/docker/v/fabiodcorreia/codimd?sort=semver&style=plastic)

A custom CodiMD image build with Alpine Linux.

## Application Modifications
To optimize the application and reduce the image size some packages were removed, for that reason
features related with these packages will not work.

### Packages Removed
- pg
- passport-bitbucket-oauth2
- passport-dropbox-oauth2
- passport-facebook
- passport-github
- passport-gitlab2
- passport-google-oauth20
- passport-twitter
- passport-ldapauth
- passport-oauth2
- passport-saml
- passport-next/passport-openid
- @aws-sdk/client-s3-node
- azure-storage
- sqlite3
- minio
- mattermost
- aws-sdk

## Versioning

This image follows the [Semantic Versioning](https://semver.org/) pattern.

- **MAJOR** version - Changes on Base Image version (1.0.0 to 2.0.0)
- **MINOR** version - Changes on CodiMD version (1.6.0 to 1.6.1)
- **PATCH** version - Package updates and other non breaking changes on the image
- **DRAFT** version - Unstable build for review (Optional)

### Version Mapping

| Version    | 1.0     | 1.1     | 2.0     |
| :----:     | ---     | ---     | ----    |
| Base Image | 1.x.x   | 1.x.x   | 2.x.x   |
| CodiMD     | 1.6.0   | 1.6.1   | 1.6.0   |

When Base Image gets upgraded the major version is incremented, when codimd gets upgraded the minor version is incremented.

## Tags

| Tag | Description |
| :----: | --- |
| latest | Latest version |
| 1.0.0 | Specific patch version |
| 1.0 | Specific minor version |
| 1 | Specific major version |
| 1.0.0-`arch` | Specific patch version to that `arch` |
| 1.0-`arch` | Specific minor version to that `arch` |
| 1-`arch` | Specific major version to that `arch` |
| test | Branch version - **DO NOT USE** |

The version tags are the same as the repository versioning tags but without the `v`. The `test` version is only for build purposes, it should not be pulled.

The `arch` can be one of the supported architectures described below.

## Supported Architectures

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64 |
| arm64 | arm64v8 |
| armhf | arm32v7 |


## Environment Variables

| Name                  | Description |
| :-------------------: | ----------- |
| PUID                  | Set the UserID - [Details](https://github.com/fabiodcorreia/docker-base-alpine#userid--groupid) |
| PGID                  | Set the GroupID - [Details](https://github.com/fabiodcorreia/docker-base-alpine#userid--groupid) |
| TZ                    | Set the system timezone - [Options](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) |
| SESSION_KEY           | Set the HTTP session key |
| DATABASE_HOST         | Set the database hostname or ip address where the application will connect |
| DATABASE_NAME         | Set the database name that will be used by the application |
| DATABASE_USER         | Set the username for the database connection |
| DATABASE_PASS         | Set the password for the database username |
| DOMAIN_NAME           | Set the application domain name in case of reverse proxy |
| LOG_LEVEL             | Set the log level `info`, `warn`, `error` (default: `info`) |
| ADD_PORT_URL          | Set the port on the url, required if the port is not 80 or 443 |
| ALLOW_REGISTER        | Set the option to register new users `true` or `false` (default: `true`) |
| ALLOW_LOGIN           | Set the option to allow user login `true` or `false` (default: `true`) |
| ALLOW_PDF_EXPORT      | Set the option to allow PDF export of notes `true` or `false` (default: `false`) |
| ALLOW_ANONYMOUS       | Set the option to allow anonymous access `true` or `false` (default: `true`) |
| ALLOW_GRAVATAR        | Set the option to use gravatar to fetch the user avatar `true` or `false` |


## Volumes and Ports

It exposes a single volume at `/config` where it keeps the configuration and other files related with the application.

Also a single port is exposed at 3000 to allow external HTTP request.

## Start Container

```bash
docker run \
  -e PUID=1000 \
  -e PGID=1000 \
  -e DATABASE_HOST=mariadb_codimd \
  -e DATABASE_NAME=codimddb \
  -e DATABASE_USER=codimduser \
  -e DATABASE_PASS=codimdpass \
  -e DOMAIN_NAME=localhost \
  -e ADD_PORT_URL=true \
  -p 3000:3000 \
  -v $PWD:/config \
  fabiodcorreia/codimd
```

Or use `docker-compose`, an example is provided on [docker-compose.yml](docker-compose.yml)
