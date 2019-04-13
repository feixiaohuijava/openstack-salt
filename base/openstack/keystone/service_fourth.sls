
# controller*

{% set ip = salt['network.interface_ip']('eth0') %}


#一下替换命令并非幂等操作
{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
httpd_services:
    cmd.run:
      - names:
         - sed -i "s/#ServerName www.example.com:80/ServerName controller01/" /etc/httpd/conf/httpd.conf
         - sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf
{% elif ip == pillar['openstack_cluster_info']['controller02']['ip'] %}
httpd_services:
    cmd.run:
      - names:
         - sed -i "s/#ServerName www.example.com:80/ServerName controller02/" /etc/httpd/conf/httpd.conf
         - sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf
{% elif ip == pillar['openstack_cluster_info']['controller03']['ip'] %}
httpd_services:
    cmd.run:
      - names:
          - sed -i "s/#ServerName www.example.com:80/ServerName controller03/" /etc/httpd/conf/httpd.conf
          - sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf
{% endif %}