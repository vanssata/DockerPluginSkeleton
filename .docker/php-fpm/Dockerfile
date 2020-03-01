FROM centos:7
RUN yum update -y && \
    yum install -y epel-release

RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y yum-utils && \
    yum-config-manager --enable remi-php73 && \
    yum -y update

RUN yum install -y php-zip wget unzip curl php-fpm php-xml php-cli php-bcmath php-dba php-gd php-intl php-mbstring php-mysql php-pdo php-soap php-pecl-apcu php-pecl-imagick php-opcache php-process

RUN useradd -M -d /opt/app -s /bin/false nginx

RUN mkdir -p /run/php-fpm && \
    chown nginx:nginx /run/php-fpm

RUN mkdir -p /var/lib/php/session && \
    chown nginx:nginx /var/lib/php/session
## ADD COMPOSER
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

## ADD NODEJS
RUN yum clean all && \
    yum -y makecache fast y gcc-c++ make
RUN curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y nodejs
## ADD YARN
RUN npm install yarn -g

COPY ./.docker/php-fpm/php-fpm.conf /etc/php-fpm.conf
COPY ./.docker/php-fpm/www.conf /etc/php-fpm.d/www.conf
COPY ./.docker/php-fpm/php.ini /etc/php.ini

RUN yum clean all

WORKDIR /opt/app

ARG COMPOSER_MEMORY_LIMIT=-1
ARG COMPOSER_ALLOW_XDEBUG=1
ARG COMPOSER_DISABLE_XDEBUG_WARN=1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_XDEBUG=1
ENV COMPOSER_DISABLE_XDEBUG_WARN=1
EXPOSE 80
EXPOSE 8080
CMD php-fpm
