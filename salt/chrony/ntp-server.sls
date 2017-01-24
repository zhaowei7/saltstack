ntp-server-install:
  pkg.installed:
    - names:
      - chrony 
  cmd.run:
    - name: setenforce 0 && timedatectl set-timezone Asia/Shanghai
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://chrony/files/chrony-server.conf
    - user: root
    - group: root
    - mode: 755
  service.running:
    - name: chronyd
    - enable: True
    - reload: True
    - watch:
      - file: ntp-server-install
    - require:
      - pkg: ntp-server-install
