# Based on https://github.com/samtux/docker-micka
FROM ubuntu:18.04

RUN apt-get -y update \
    && apt-get install -y software-properties-common git --no-install-recommends \
    && apt-get clean

RUN add-apt-repository -y ppa:ondrej/php \
    && apt -y update

RUN set -x \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nginx \
    php7.4 php7.4-fpm php7.4-xsl php7.4-pgsql php7.4-curl \
    python3-psycopg2 \
    zip unzip php7.4-zip curl

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    # Make sure we're installing what we think we're installing!
    && php7.4 -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php7.4 /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

COPY micka-custom /var/www/html/Micka

RUN cd /var/www/html/Micka \
    && cd php \
    && php7.4 /usr/local/bin/composer install \
    && mkdir -p temp log \
    && chmod -Rfv a+rwx  log/ temp/ \
    && cp /var/www/html/Micka/php/app/config/codelists.xml.dist /var/www/html/Micka/php/app/config/codelists.xml \
    && cp /var/www/html/Micka/php/app/config/config.neon.dist /var/www/html/Micka/php/app/config/config.neon

RUN cd /var/www/html \
    && chmod -R ugo+rx Micka
