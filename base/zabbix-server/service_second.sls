add_zabbix_yum_reposity:
    cmd.run:
       - name: rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

refresh_yum_cache:
     cmd.run:
        - name: |
           yum clean all
           yum makecache
           yum-config-manager --enable rhel-7-server-optional-rpms

install_zabbix_server:
   pkg.installed:
       - pkgs:
          - zabbix-server-mysql
          - zabbix-web-mysql
          - mariadb
          - mariadb-server

start_server_mariadb:
   server.running:
      - name: mariadb
      - enable: True

start_server_httpd:
    server.running:
      - name: httpd
      - enable: True


mysql_secure_installation:
   cmd.run:
     - name: |
          mysql -e "GRANT ALL PRIVILEGES ON *.* to 'root'@'localhost' identified BY 'zabbix';"
          mysql -uroot -pzabbix -e "DROP DATABASE test;"
          mysql -uroot -pzabbix -e "create database zabbix character set utf8 collate utf8_bin;"
          mysql -uroot -pzabbix -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"

zabbix_sql_to_mariadb:
   cmd.run:
    - name: zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix


{% set DBName = pillar['zabbix']['DBName'] %}
{% set DBUser = pillar['zabbix']['DBUser'] %}
{% set DBPassword = pillar['zabbix']['DBPassword'] %}

cp_zabbix_server.conf:
   file.managed:
      - name: /etc/zabbix/zabbix_server.conf
      - source: salt://zabbix-server/files/zabbix_server.conf
      - template: jinja
      - defaults:
          DBName: {{ DBName }}
          DBUser: {{ DBUser }}
          DBPassword: {{ DBPassword }}

start_server_zabbix:
    server.running:
        - name: zabbix-server
        - enalbe: True

restart_server_httpd:
    server.running:
        - name: httpd
        - reload: True
