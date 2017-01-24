{% set version = 'php-5.6.29' %}
pkg-php:
  pkg.installed:
    - names:
      - mysql-devel
      - openssl-devel
      - swig
      - libjpeg-turbo
      - libjpeg-turbo-devel
      - libpng
      - libpng-devel
      - freetype
      - freetype-devel
      - libxml2
      - libxml2-devel
      - zlib
      - zlib-devel
      - libcurl
      - libcurl-devel

php-source-install:
  file.managed:
    - name: /usr/local/src/{{ version }}.tar.gz
    - source: salt://php56/files/{{ version }}.tar.gz
    - user: root
    - group: root
    - mode: 755

  cmd.run:
    - name: cd /usr/local/src && tar zxf {{ version }}.tar.gz && cd {{ version }} &&  ./configure --prefix=/usr/local/{{ version }} --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-mysql=mysqlnd --with-jpeg-dir --with-png-dir --with-zlib --enable-xml  --with-libxml-dir --with-curl --enable-bcmath --enable-shmop --enable-sysvsem  --enable-inline-optimization --enable-mbregex --with-openssl --enable-mbstring --with-gd --enable-gd-native-ttf --with-freetype-dir=/usr/lib64 --with-gettext=/usr/lib64 --enable-sockets --with-xmlrpc --enable-zip --enable-soap --disable-debug --enable-opcache --enable-zip --with-config-file-path=/usr/local/{{ version }}/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www && make && make install && mkdir -p /usr/local/{{ version }}/logs && chown -R www.www /usr/local/{{ version }}
    - require:
      - file: php-source-install
    - unless: test -d /usr/local/{{ version }}

pdo-plugin:
  cmd.run:
    - name: cd /usr/local/src/{{ version }}/ext/pdo_mysql/ && /usr/local/{{ version }}/bin/phpize && ./configure --with-php-config=/usr/local/{{ version }}/bin/php-config &&  make && make install
    - unless: test -f /usr/local/{{ version }}/lib/php/extensions/*/pdo_mysql.so
    - require:
      - cmd: php-source-install

php-ini:
  file.managed:
    - name: /usr/local/{{ version }}/etc/php.ini
    - source: salt://php56/files/php.ini-production
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      version: {{ version }}

php-fpm:
  file.managed:
    - name: /usr/local/{{ version }}/etc/php-fpm.conf
    - source: salt://php56/files/php-fpm.conf.default
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      version: {{ version }}
php-fastcgi-service:
  file.managed:
    - name: /etc/init.d/php-fpm
    - source: salt://php56/files/init.d.php-fpm
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: chkconfig --add php-fpm
    - unless: chkconfig --list | grep php-fpm
    - require:
      - file: php-fastcgi-service
  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - cmd: php-fastcgi-service
    - watch:
      - file: php-ini
      - file: php-fpm
#create nginx link
link-php56:
  cmd.run:
    - name: ln -sfn /usr/local/{{ version }}  /application/php && chown -R www.www /application 
    - unless: test -L /application/php
