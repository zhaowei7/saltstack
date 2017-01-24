{% set version = 'php-5.6.29' %}
redis-plugin:
  file.managed:
    - name: /usr/local/src/redis-2.2.7.tgz
    - source: salt://php56/files/redis-2.2.7.tgz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar zxf redis-2.2.7.tgz && cd redis-2.2.7 && /usr/local/{{ version }}/bin/phpize && ./configure --with-php-config=/usr/local/{{ version }}/bin/php-config &&  make && make install
    - unless: test -f /usr/local/{{ version }}/lib/php/extensions/*/redis.so
  require:
    - file: redis-plugin
    - cmd: php-install

/usr/local/{{ version }}/etc/php.ini:
  file.append:
    - text:
      - extension=redis.so
