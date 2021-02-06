ARG PHP_VERSION=8.0.0
FROM composer:latest AS composer
FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Oleksii Bulba <oleksii.bulba@gmail.com>"

WORKDIR /app

# Install PHP modules
RUN apk add --no-cache --virtual \
        .phpize-deps $PHPIZE_DEPS \
        autoconf \
        pkgconf \
        libssl1.0 \
        openssl-dev \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        git \
        libsodium-dev \
        openssh-client \
        curl \
        wget \
        libtool \
        zlib-dev \
        icu-dev \
        g++ \
        linux-headers > /dev/null \
    && pecl bundle -d /usr/src/php/ext redis \
    && docker-php-ext-install -j2 redis \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j2 intl \
    && pecl bundle -d /usr/src/php/ext mcrypt \
    && docker-php-ext-configure mcrypt \
    && pecl bundle -d /usr/src/php/ext apcu \
    && docker-php-ext-install -j2 apcu \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j2 bcmath gd iconv mbstring mcrypt zip \
    && docker-php-ext-enable opcache \
    && rm /usr/src/php/ext/*.tgz \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN pecl channel-update pecl.php.net \
  # && pecl install mongodb \
  # && docker-php-ext-enable mongodb \
    && composer global require "phpunit/phpunit" \
    && export PATH=$PATH:/root/.composer/vendor/bin \
    && ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit

CMD ["php-fpm"]
