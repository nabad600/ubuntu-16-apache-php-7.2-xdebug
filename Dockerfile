FROM 1and1internet/ubuntu-16-apache-php-7.2


# references
#
# https://hub.docker.com/r/1and1internet/ubuntu-16-apache-php-7.2/
# https://github.com/1and1internet/ubuntu-16-apache-php-7.2

# https://hub.docker.com/r/1and1internet/ubuntu-16-apache/
# https://github.com/1and1internet/ubuntu-16-apache

# https://hub.docker.com/r/1and1internet/ubuntu-16/
# https://github.com/1and1internet/ubuntu-16

RUN a2enmod rewrite


RUN apt-get update && apt-get install \
  --allow-unauthenticated -y \
  php7.2-gd php7.2-xml php7.2-mcrypt php7.2-curl php7.2-intl php7.2-zip php7.2-soap \
  php7.2-xdebug php7.2-tidy \
  build-essential nodejs supervisor \
  git subversion \
  htop mc iputils-ping

# get new composer version
RUN cd /tmp && \
  echo "getting composer ..." && \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  chmod a+x /usr/local/bin/composer && \
  composer -V

RUN sed -i -e 's/memory_limit = 512M/memory_limit = -1/g' /etc/php/7.2/apache2/php.ini \
      && echo "xdebug.remote_enable=on" >> /etc/php/7.2/mods-available/xdebug.ini \
      && echo "xdebug.remote_autostart=off" >> /etc/php/7.2/mods-available/xdebug.ini \
      && echo "xdebug.remote_port=9000" >> /etc/php/7.2/mods-available/xdebug.ini \
      && echo "xdebug.remote_handler=dbgp" >> /etc/php/7.2/mods-available/xdebug.ini \
      && echo "xdebug.remote_connect_back=1" >> /etc/php/7.2/mods-available/xdebug.ini \
# not activating opcache for cli - incompatible to composer
#      && echo "opcache.enable_cli=1" >> /etc/php/7.2/mods-available/opcache.ini \
      && echo "opcache.memory_consumption=256" >> /etc/php/7.2/mods-available/opcache.ini \
      && echo "opcache.file_cache=/tmp/opcache" >> /etc/php/7.2/mods-available/opcache.ini \
      && mkdir /tmp/opcache

RUN chmod 777 /tmp/opcache
