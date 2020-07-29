FROM ruby:2.5.1
LABEL maintainer="xinyu <2609746800@qq.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        unzip \
        supervisor \
        libssl-dev \
    && rm -rf /var/lib/apt/list/*

RUN mkdir /app
WORKDIR /app/

ADD Gemfile* /app/
RUN gem install bundler -v '<2' && bundler install --deployment --jobs 4 --without development test

ARG APP_COMMIT
ENV APP_COMMIT ${APP_COMMIT}

ARG APP_ENV
ENV APP_ENV ${APP_ENV}

ARG APP_NAME
ENV APP_NAME ${APP_NAME}

ARG APP_VERSION
ENV APP_VERSION ${APP_VERSION}

ARG VAULT_TOKEN
ENV VAULT_TOKEN ${VAULT_TOKEN}

ENV RAILS_ENV=production

ADD . /app/
# RUN ["bin/bash", "-C", "docker-build.sh"]
RUN ["bin/bash", "-C", "docker-migrate.sh"]
RUN ["bin/bash", "-C", "docker-build-assets.sh"]

EXPOSE 3000

ENTRYPOINT ["bin/bash", "-C", "docker-entrypoint.sh"]
