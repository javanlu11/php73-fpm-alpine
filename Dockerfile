FROM php:7.3-fpm-alpine

ARG PHPREDIS_VERSION="${PHPREDIS_VERSION:-4.2.0}"
ENV PHPREDIS_VERSION="${PHPREDIS_VERSION}"

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz && \
    tar xfz /tmp/redis.tar.gz && \
    rm -r /tmp/redis.tar.gz && \
    mkdir -p /usr/src/php/ext && \
    mv phpredis-${PHPREDIS_VERSION} /usr/src/php/ext/redis

RUN docker-php-ext-configure opcache --enable-opcache \
    && apk add --no-cache libzip-dev \
    && docker-php-ext-configure zip --with-libzip=/usr/include \
    && docker-php-ext-install pdo pdo_mysql opcache redis zip \
    && rm -rf /tmp/* /var/cache/apk/*
