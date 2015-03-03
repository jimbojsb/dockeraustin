FROM phusion/baseimage:0.9.16

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DEBIAN_FRONTEND noninteractive

RUN echo "America/Chicago" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# locale nonsense for php repo
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# update apt
RUN apt-add-repository -y ppa:ondrej/php5-5.6
RUN apt-get update
RUN apt-get install -qqy --force-yes curl git php5-cli php5-common php5-fpm ca-certificates nginx

RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php5/cli/php.ini
RUN sed -i '/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/c\error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE' /etc/php5/cli/php.ini
RUN sed -i '/short_open_tag = Off/c\short_open_tag = On' /etc/php5/fpm/php.ini
RUN sed -i '/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/c\error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE' /etc/php5/fpm/php.ini
RUN sed -i '/memory_limit = -1/c\memory_limit = 256M' /etc/php5/cli/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD docker/nginx.conf /etc/nginx/sites-available/default

# enable nginx and php5-fpm runit
ADD docker/nginx.sh /etc/service/nginx/run
ADD docker/php-fpm.sh /etc/service/php5-fpm/run

ADD src /myapp/src/
ADD public /myapp/public/

ADD composer.json composer.lock /myapp/
RUN /bin/bash -l -c "cd /myapp && /usr/local/composer.phar install --no-dev && /usr/local/composer.phar dump-autoload --no-dev --optimize"

EXPOSE 80