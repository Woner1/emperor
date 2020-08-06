#!/bin/bash

set -euo 
IFS=$'\n\t'

APP_NAME=$1
APP_ENV=$2
APP_VERSION=$3
APP_COMMIT=$4
IMAGE_TAG=$5
ECR_REGISTRY=$6

# build rails application image
# emperor_hk_test_xxxxx
docker build -t $ECR_REGISTRY/$APP_NAME:${APP_ENV}_${IMAGE_TAG} -f Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" .

# build nginx for api endponit
# emperor_hk_test_xxxxx_nginx_api
SUFFIX="nginx_api"
docker build -t "$APP_NAME:${APP_ENV}_${IMAGE_TAG}_${SUFFIX}" -f ./nginx/api/Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" ./nginx/api/

# build nginx for admin endponit
# emperor_hk_test_xxxxx_nginx_admin
SUFFIX="nginx_admin"
docker build -t "$APP_NAME:${APP_ENV}_${IMAGE_TAG}_${SUFFIX}" -f ./nginx/admin/Dockerfile --force-rm \
    --build-arg APP_NAME="$APP_NAME" \
    --build-arg APP_ENV="$APP_ENV" \
    --build-arg APP_COMMIT="$APP_COMMIT" ./nginx/admin/
