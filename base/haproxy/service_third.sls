# controller01, controller02, controller03
cp_mysqlchk:
   file.managed:
      - name: /etc/xinetd.d/mysqlchk
      - source: salt://haproxy/files/mysqlchk
      - mode: 644

/etc/services:
  file.append:
    - text: |
        mysqlchk        9200/tcp                # mysqlchk


restart_service_xinetd:
    cmd.run:
       - name: systemctl restart xinetd.service

wait_restart_xinetd:
    cmd.run:
       - name: sleep 1


see_service_xinetd:
    cmd.run:
       - name: systemctl status xinetd.service