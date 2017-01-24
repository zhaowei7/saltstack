nginx_require_pkg:
  pkg.installed:
    - names:
      - gcc
      - gcc-c++
      - openssl-devel
      - pcre-devel
      - zlib-devel
      - make
      - libaio
      - libaio-devel
    
