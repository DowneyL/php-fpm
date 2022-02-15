#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM august5th/php:7.1-fpm-bullseye

LABEL maintainer="Mahmoud Zalt <mahmoud@zalt.me>"

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#
# Installing tools and PHP extentions using "apt", "docker-php", "pecl",
#

# Install "curl", "libmemcached-dev", "libpq-dev", "libjpeg-dev",
#         "libpng12-dev", "libfreetype6-dev", "libssl-dev", "libmcrypt-dev",
RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libssl-dev \
            libwebp-dev \
            libmcrypt-dev; \
    # cleanup
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	curl -O http://mirror.ossplanet.net/nongnu/freetype/freetype-old/freetype-2.6.5.tar.gz; \
	tar -zxvf freetype-2.6.5.tar.gz; \
	cd freetype-2.6.5; \
	./configure --prefix=/usr; \
	make && make install; \
	rm -rf /var/www/html/freetype*

RUN set -eux; \
    # Install the PHP mcrypt extention
    docker-php-ext-install mcrypt; \
    # Install the PHP pdo_mysql extention
    docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install pdo_pgsql; \
    # Install the PHP gd library
    docker-php-ext-configure gd \
            --enable-gd-native-ttf \
            --with-jpeg-dir=/usr/lib \
            --with-webp-dir=/usr/lib \
            --with-freetype-dir; \
    docker-php-ext-install gd; \
    php -r 'var_dump(gd_info());'
