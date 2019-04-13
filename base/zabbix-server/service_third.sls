backup_graphfont.ttf:
    cmd.run:
       - name: mv graphfont.ttf graphfont.ttf.bak

cp_msyh.ttc:
    file.managed:
       - name: /usr/share/zabbix/fonts/msyh.ttc
       - source: salt://zabbix-server/files/msyh.ttc

restart_server_zabbix-server:
    service.running:
       - name: zabbix-server

