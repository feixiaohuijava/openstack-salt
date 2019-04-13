keystone_install:
    pkg.installed:
    - pkgs:
      - openstack-keystone
      - httpd
      - mod_wsgi
      - python2-openstackclient
      - openstack-utils
