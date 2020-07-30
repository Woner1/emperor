#!/bin/bash

set -euo 
IFS=$'\n\t'

APP_NAME=$1
APP_ENV=$2
APP_VERSION=$3
APP_COMMIT=$4
IMAGE_TAG=$5

# build rails application image
docker build -t $APP_NAME:${APP_ENV}_${IMAGE_TAG} -f Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" .

# build nginx for api endponit
SUFFIX="nginx-api"
docker build -t "$APP_NAME:${APP_ENV}_${IMAGE_TAG}_${SUFFIX}" -f ./nginx/api/Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" ./nginx/api/

# build nginx for admin endponit
SUFFIX="nginx-admin"
docker build -t "$APP_NAME:${APP_ENV}_${IMAGE_TAG}_${SUFFIX}" -f ./nginx/admin/Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" ./nginx/admin/
