ntp-client-install:
  pkg.installed:
    - names:
      - chrony 
  cmd.run:
    - name: setenforce 0 && timedatectl set-timezone Asia/Shanghai
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://chrony/files/chrony-client.conf
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      ntp_server: 192.168.1.222
  service.running:
    - name: chronyd
    - enable: True
    - reload: True
    - watch:
      - file: ntp-client-install
    - require:
      - pkg: ntp-client-install
