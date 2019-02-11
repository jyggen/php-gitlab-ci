#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM php:7.0-alpine as base
LABEL maintainer="Jonas Stendahl <jonas@stendahl.me>" php="7.0"
RUN apk add --no-cache git freetype-dev icu-dev jpeg-dev libmcrypt-dev libxml2-dev libzip-dev make \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath intl mcrypt pcntl pdo soap sockets zip \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd pdo_mysql \
    && touch /usr/local/etc/php/php.ini && echo "memory_limit = 512M" > /usr/local/etc/php/php.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer global require hirak/prestissimo && rm -rf /root/.composer/cache
