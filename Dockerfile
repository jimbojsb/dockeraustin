FROM phusion/baseimage:0.9.16

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DEBIAN_FRONTEND noninteractive

RUN echo "America/Chicago" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# update apt
RUN apt-add-repository -y ppa:ondrej/php5-5.6
RUN apt-get update && apt-get dist-upgrade -y --force-yes
RUN apt-get install -qqy --force-yes curl git php5-cli php5-common php5-fpm php5-cgi php-apc php-pear php5-imagick php5-mysql php5-curl php5-mcrypt php5-sqlite php5-gd php5-imap php5-xsl ca-certificates wget nginx nodejs npm

RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php5/cli/php.ini
RUN sed -i '/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/c\error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE' /etc/php5/cli/php.ini
RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php5/fpm/php.ini
RUN sed -i '/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/c\error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE' /etc/php5/fpm/php.ini
RUN sed -i '/memory_limit = -1/c\memory_limit = 256M' /etc/php5/cli/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD src /myapp/src/
ADD docker /myapp/docker/
ADD public /myapp/public/

ADD composer.json composer.lock /orca/
RUN /bin/bash -l -c "cd /myapp && /usr/local/composer.phar install --no-dev && /usr/local/composer.phar dump-autoload --no-dev --optimize"

EXPOSE 80