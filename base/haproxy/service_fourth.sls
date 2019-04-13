# controller01,controller02,controller03
start_service_haproxy:
    service.running:
       - name: haproxy
       - enable: True
#    cmd.run:
#       - name: systemctl enable haproxy.service && systemctl start haproxy.service && systemctl status haproxy.service&& systemctl list-unit-files|grep haproxy.service

start_service_keepalived:
    service.running:
       - name: keepalived
       - enable: True
#    cmd.run:
#       - name: systemctl enable keepalived.service && systemctl start keepalived.service && systemctl status keepalived.service&& systemctl list-unit-files|grep keepalived.service

