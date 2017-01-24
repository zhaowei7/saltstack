include:
  - nginx.pkg
{% set version = '1.10.2'  %}
#user:www,passwd:Aa@think1,cmd:openssl passwd  -1 
nginx_user:
  user.present:
    - name: www
    - uid: 1501
    - gid_from_name: True
    - unless: test -d /home/www
nginx-install:
  file.managed:
    - name: /usr/local/src/nginx-{{ version }}.tar.gz
    - source: salt://nginx/soft/nginx-{{ version }}.tar.gz  
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /usr/local/src/ && tar -zxf nginx-{{ version }}.tar.gz && cd nginx-{{ version }} && ./configure --prefix=/usr/local/webserver/nginx-{{ version }}/ --user=www --group=www  --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-file-aio --with-http_realip_module --with-pcre --with-threads && make && make install
    - unless: test -d /usr/local/webserver/nginx-{{ version }}
  require:
    - file: nginx-install
    - pkg: nginx_require_pkg    
    - user: nginx_user
#nginx sysconf
/etc/sysconfig/nginx:
  file.managed:
    - source: salt://nginx/files/nginx.sysconf
    - user: root
    - group: root
    - mode: 755
#start script
nginx-start-conf:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx/files/nginx
    - user: root
    - group: root 
    - mode: 755
  cmd.run:
    - name: chkconfig --add nginx 
    - unless: chkconfig --list nginx 

#create logs dir
create-nginx-logs-dir:
  cmd.run:
    - name: mkdir -p /usr/local/webserver/nginx-{{ version }}/logs/access && mkdir -p /usr/local/webserver/nginx-{{ version }}/logs/error && chown -R www.www /usr/local/webserver/nginx-{{ version }}
    - unless: test -d /usr/local/webserver/nginx-{{ version }}/logs/access

#nginx logs cut
nginx-logs-cut:
  file.managed:
    - name: /usr/local/webserver/nginx-{{ version }}/sbin/nginx_cut.sh
    - source: salt://nginx/files/nginx_cut.sh
    - mode: 755 
  cron.present:         
    - name: sh /application/nginx/sbin/nginx_cut.sh
    - user: root
    - minute: 10
    - hour: 0
    - require:
      - file: nginx-logs-cut
    - unless: test -f /application/nginx/sbin/nginx_cut.sh
#web application dir
application-dir:
  cmd.run:
    - name: mkdir /application 
    - unless: test -d /application
#create nginx link
link-nginx:
  cmd.run:
    - name: ln -sfn /usr/local/webserver/nginx-{{ version }}  /application/nginx && chown -R www.www /application 
    - unless: test -L /application/nginx

########################################################################
# configure file manager
#nginx.conf
nginx-conf:
  file.managed:
    - name: /application/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - user: www
    - group: www
    - mode: 644
    - template: jinja

#vhost configure file
vhost-conf:
  cmd.run:
    - name: mkdir -p /usr/local/webserver/nginx-{{ version }}/conf/conf.d
    - unless: test -d /usr/local/webserver/nginx-{{ version }}/conf/conf.d
  file.managed:
    - name: /usr/local/webserver/nginx-{{ version }}/conf/conf.d/php_info.conf
    - source: salt://nginx/files/php_info.conf
    - user: www
    - group: www
    - mode: 644
    - template: jinja
    - defaults:
      php_info_port: {{ pillar['php_info_port'] }} 
      php_info_path: {{ pillar['php_info_path']  }}
      php_info_servername: {{ pillar['php_info_servername'] }}
      php_info_log: {{ pillar['php_info_log']  }}
      Zabbix_Server: {{ pillar['Zabbix_Server'] }}
#service manage
nginx-configure-file-manager:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx-conf
      - file: vhost-conf
