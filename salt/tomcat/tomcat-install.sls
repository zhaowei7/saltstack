include:
  - jdk.jdk-install
  - tomcat.split-catalina
{% set version = '7.0.70' %}
#default pw cloudcc123-
tomcat_user:
  user.present:
    - name: tomcat
    - uid: 1505
    - gid_from_name: True
    - shell: /bin/bash
    - password: '$6$eEo8Tk63$bdt6KQSiEl6QWZbrsRxQ.jYZc1uy6IxCTSDJIDbYqq6zLlEWLRDK//IBcOFEdhY0xjfgX8o.t2513paZJnFkB.'
    - unless: test -d /home/tomcat
tomcat-install:
  file.managed:
    - name: /usr/local/src/apache-tomcat-{{ version }}.tar.gz
    - source: salt://tomcat/soft/apache-tomcat-{{ version }}.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar -zxf apache-tomcat-{{ version }}.tar.gz && cp -rfa apache-tomcat-{{ version }} /usr/local/webserver/ && ln -sfn /usr/local/webserver/apache-tomcat-{{ version }}  /application/tomcat && chown -R tomcat.tomcat /usr/local/webserver/apache-tomcat-{{ version }} 
    - unless: test -d /usr/local/webserver/apache-tomcat-{{ version }}    
tomcat-catalina-conf:
  file.managed:
    - name: /application/tomcat/bin/catalina.sh
    - source: salt://tomcat/files/catalina.sh
    - user: tomcat
    - group: tomcat
    - mode: 755
    - template: jinja
    - defaults:
      gc_log: /usr/local/webserver/apache-tomcat-{{ version }}/logs/gc.log
      GCThreads: {{ grains['num_cpus'] }}
      Xmx: 4096m
      Xms: 4096m
      Xmn: 1024m
      Xss: 512k
      PermSize: 512m
      MaxPermSize: 512m
      jmx_port: 5252
      jmx_host: {{ grains['ipv4'][1] }}
tomcat-server-conf:
  file.managed:
    - name: /application/tomcat/conf/server.xml
    - source: salt://tomcat/files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 755
    - template: jinja
    - defaults:
      PORT: 8080
tomcat-web-conf:
  file.managed:
    - name: /application/tomcat/conf/web.xml
    - source: salt://tomcat/files/web.xml
    - user: tomcat
    - group: tomcat
    - mode: 755
