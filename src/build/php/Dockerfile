ARG PHP_VERSION=8.1.3
FROM php:${PHP_VERSION}-fpm

ENV INSTALL_DIR /var/www/html
ENV SSH_USER root
ENV SSH_PASSWORD root

# sodium
# php ^7.2
RUN apt-get update && apt-cache search libsodium && apt-get install -y libsodium-dev # libsodium18

# Install System Dependencies
RUN requirements="libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libpng-dev libfreetype6-dev libicu-dev libxslt1-dev" \
    apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libpng-dev libfreetype6-dev libicu-dev libxslt1-dev \
	libicu-dev \
    libssl-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \
	apt-utils \
	gnupg \
	redis-tools \
	default-mysql-client \
	git \
	vim \
	nano \
	wget \
	curl \
	lynx \
	psmisc \
	libzip-dev \
	libonig-dev \
	unzip \
	tar \
	cron \
	bash-completion \
	&& apt-get clean

# Install XDebug
RUN yes | pecl install xdebug && \
	echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/php-ext-xdebug.ini

RUN docker-php-ext-configure \
  	   gd --with-freetype=/usr/include/ \
  	      --with-jpeg=/usr/include/ \
  	&& docker-php-ext-install gd \
  	&& docker-php-ext-install zip \
  	&& docker-php-ext-install intl \
  	&& docker-php-ext-install xsl \
  	&& docker-php-ext-install soap \
  	&& docker-php-ext-install bcmath \
  	&& docker-php-ext-install sodium \
  	&& docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
  	&& docker-php-ext-enable xdebug \
    && apt-get purge --auto-remove -y libcurl3-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev

# Install OpenSSH server
RUN apt-get update \
    && apt-get install -y openssh-server \
    sudo \
    openssh-server
RUN mkdir /var/run/sshd
RUN echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

# Install oAuth
RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
  	# php-pear \
  	&& pecl install oauth \
  	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# Install Node, NVM, NPM and Grunt
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  	&& apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | sh \
    && npm i -g grunt-cli yarn requirejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

RUN echo "memory_limit=2048M" >> /usr/local/etc/php/conf.d/common.ini \
	&& echo "max_execution_time=1000" >> /usr/local/etc/php/conf.d/common.ini \
	&& echo "max_input_time=1000" >> /usr/local/etc/php/conf.d/common.ini

# Install Mhsendmail
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

# Configuring system
COPY ./config/ini/ /usr/local/etc/php/conf.d/
COPY ./config/php-fpm/ /usr/local/etc/php-fpm/
COPY ./bin/* /usr/local/bin/
COPY ./users/* /var/www/
COPY ./config/crontab /etc/cron.d/crontab
RUN chmod +x /usr/local/bin/*

RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data

COPY ./bin/ /docker/scripts
RUN chown -R www-data /docker/scripts/*
RUN chmod ug+rx /docker/scripts/*

VOLUME ${INSTALL_DIR}
WORKDIR ${INSTALL_DIR}
USER www-data

CMD bash -c '/docker/scripts/entrypoint'