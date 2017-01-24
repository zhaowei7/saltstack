memcached-install:
  pkg.installed:
    - names:
      - memcached
      - python-memcached
  service.running:
    - name: memcached
    - enable: True
