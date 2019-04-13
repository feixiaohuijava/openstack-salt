# controller*

wsgi_keystone:
    file.managed:
    - name: /etc/httpd/conf.d/wsgi-keystone.conf
    - source: salt://openstack/keystone/files/wsgi-keystone.conf