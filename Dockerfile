# Base image version
FROM php:7.2-fpm-alpine as php

FROM alpine:3.13.5 as dl
WORKDIR /app
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
  echo "**** Fake Pages  ****"
COPY ./html/ .

FROM php as php-ext-mysqli
RUN docker-php-ext-install -j"$(nproc)" mysqli

FROM php as php-ext-pdo_mysql
RUN docker-php-ext-install -j"$(nproc)" pdo_mysql

# FROM php as php-ext-pdo_pgsql 
# RUN \
#  echo "**** install packages ****" && \
#  apk add --no-cache \
#    postgresql-dev && \
#  docker-php-ext-install -j"$(nproc)" pdo_pgsql 

FROM php as php-ext-exif
RUN docker-php-ext-install -j"$(nproc)" exif

FROM php as php-ext-pcntl
RUN docker-php-ext-install -j"$(nproc)" pcntl

FROM php as php-ext-pdo
RUN docker-php-ext-install -j"$(nproc)" pdo

FROM php as php-ext-bcmath
RUN docker-php-ext-install -j"$(nproc)" bcmath

FROM php as php-ext-gd
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    libpng-dev=1.6.37-r1 \
    libjpeg-turbo-dev=2.1.0-r0 && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ && \
  docker-php-ext-install -j"$(nproc)" gd

FROM php as php-ext-mbstring
RUN docker-php-ext-install -j"$(nproc)" mbstring

FROM php as php-ext-snmp
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    net-snmp \
    net-snmp-dev && \
  docker-php-ext-install -j"$(nproc)" snmp

FROM php as php-ext-zip
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    libzip-dev \
    zip  && \
  docker-php-ext-configure zip --with-libzip && \
  docker-php-ext-install -j"$(nproc)" zip


FROM php as php-ext-redis
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache --update --virtual .build-deps \
    libzip-dev \
    .build-deps autoconf gcc cmake g++ make

# Install XDebug
RUN pecl install xdebug && \
  rm -rf /tmp/pear && \
  docker-php-ext-enable xdebug 

# Install igbinary
RUN pecl install igbinary \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable igbinary

# Install redis driver
RUN mkdir -p /tmp/pear \
    && cd /tmp/pear \
    && pecl bundle redis \
    && cd redis \
    && phpize . \
    && ./configure --enable-redis-igbinary \
    && make \
    && make install \
    && cd ~ \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

FROM php as php-ext-gettext
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    icu-dev \
    gettext \
    gettext-dev && \
  docker-php-ext-configure intl && \
  docker-php-ext-configure gettext && \
  docker-php-ext-install -j"$(nproc)"  intl \
    gettext

FROM php as php-ext-ldap
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    openldap-dev && \
  docker-php-ext-install -j"$(nproc)"  ldap 

FROM php
ARG VERSION
LABEL build_version="Version:- ${VERSION}"
LABEL maintainer="newargus"
ARG TZ
ENV TZ $(TZ)

COPY --from=php-ext-mysqli /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-mysqli /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-pdo_mysql /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-pdo_mysql /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-mbstring /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-mbstring /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-exif /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-exif /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-pcntl /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-pcntl /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-pdo /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-pdo /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-bcmath /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-bcmath /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-gd /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-gd /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-zip /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-zip /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-snmp /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-snmp /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-redis /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-redis /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-gettext /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-gettext /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

COPY --from=php-ext-ldap /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=php-ext-ldap /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

WORKDIR /var/www/html
COPY --from=dl /app .
COPY ./entrypoint.sh /entrypoint.sh
COPY ./config/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./config/app.conf  /etc/apache2/conf.d/app.conf
RUN \
  echo "**** Add Local to alpine dist ****"
ENV MUSL_LOCALE_DEPS cmake make musl-dev gcc gettext-dev libintl 
ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

RUN apk add --no-cache \
    $MUSL_LOCALE_DEPS \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
      && cd musl-locales-master \
      && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
      && cd .. && rm -r musl-locales-master \
      && rm musl-locales-master.zip

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    graphviz \
    mariadb-client \
    freetype=2.10.4-r1 \
    libpng=1.6.37-r1 \
    libjpeg-turbo=2.1.0-r0 \
    freetype-dev=2.10.4-r1 \
    libpng-dev=1.6.37-r1 \
    libjpeg-turbo-dev=2.1.0-r0 \
    icu-libs=67.1-r0 \
    jpegoptim=1.4.6-r0 \
    optipng=0.7.7-r0 \
    pngquant=2.12.6-r0 \
    gifsicle=1.92-r0 \
    supervisor=4.2.0-r0 \
    apache2=2.4.53-r0 \
    apache2-ctl=2.4.53-r0 \
    apache2-proxy=2.4.53-r0 \
    tzdata=2022a-r0 \
    libzip-dev \
    net-snmp-dev \
    openldap-dev
    
RUN \   
  echo "**** cleanup ****" && \
  rm -rf /tmp/* && \
  chown www-data -R . && \
  chmod +x /entrypoint.sh

RUN \   
  echo "**** configure supervisord ****" && \
  sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf && \
  sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf && \
  sed -i '$iLoadModule proxy_module modules/mod_proxy.so' /etc/apache2/httpd.conf

RUN \    
  mkdir -p "/data" && mkdir -p "/data/sessions"  && \
  chown www-data:www-data /data && \
  chmod 0777 /data

VOLUME [ "/data" ]
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80 9000