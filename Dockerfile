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
    php5.6-fpm php5.6-xsl php5.6-pgsql php5.6-curl \
    python3-psycopg2 \
    zip unzip php5.6-zip curl

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    # Make sure we're installing what we think we're installing!
    && php5.6 -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php5.6 /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

RUN cd /var/www/html/ \
    && git clone https://github.com/hsrs-cz/Micka.git \
    && cd Micka \
    && git checkout e6f083bb2cf6a54a1893e97b7525d3369fa64b1e \
    && cd php \
    && php5.6 /usr/local/bin/composer install \
    && mkdir -p temp log \
    && chmod -Rfv a+rwx  log/ temp/ \
    && cp /var/www/html/Micka/php/app/config/codelists.xml.dist /var/www/html/Micka/php/app/config/codelists.xml
