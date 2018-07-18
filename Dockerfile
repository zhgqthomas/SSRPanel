FROM php:7.1.19-fpm
MAINTAINER zhgqthomas <zhgqthomas@gmail.com>

######
# You can install php extensions using docker-php-ext-install
######

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install fileinfo \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring

WORKDIR /usr/share/nginx/html
ADD . /usr/share/nginx/html

EXPOSE 9000

RUN php composer.phar install \
	&& php artisan key:generate \
	&& chmod -R 777 storage/ \
