#!/bin/bash

IMAGE_NAME="codimd"
docker image rm ${IMAGE_NAME}
docker build . -t ${IMAGE_NAME}
docker run --rm --entrypoint '/bin/sh' -v ${PWD}:/tmp ${IMAGE_NAME} -c '\
  apk info -v | sort > /tmp/package_versions.txt && \
  echo "===== NPM Packages =====" >> /tmp/package_versions.txt && \
  npm list --depth=0 >> /tmp/package_versions.txt && \
  chmod 777 /tmp/package_versions.txt'
