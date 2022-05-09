FROM php:8.1-fpm-buster

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
    cron \
    default-mysql-client \
    git \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    lsof \
    mailutils \
    msmtp \
    procps \
    vim \
    zip \
  && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pecl.php.net && pecl install \
    imagick \
    redis \
    ssh2-1.3.1 \
    xdebug \
  && pecl clear-cache \
  && rm -rf /tmp/pear

RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip \
  && docker-php-ext-enable \
    imagick \
    redis \
    ssh2 \
    xdebug

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN groupadd -g 1000 app \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash app
RUN mkdir -p /var/www/html \
   && chown -R app:app /var/www

COPY conf/php.ini $PHP_INI_DIR

USER app:app
VOLUME /var/www
WORKDIR /var/www/html