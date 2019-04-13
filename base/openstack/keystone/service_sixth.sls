#controller*

httpd.service:
   service.running:
      - enable: True
      - name: httpd

memcached.service:
   cmd.run:
      - names:
            - systemctl restart memcached
            - systemctl status memcached

http.service_reload:
    cmd.run:
        - names:
            - systemctl restart httpd
            - systemctl status httpd