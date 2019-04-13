node_compute_install:
  pkg.installed:
    - pkgs:
      - openstack-nova-compute
      - openstack-utils
      - python2-openstackclient
      - targetcli
      - python-keystone
      - yum-plugin-priorities
      - conntrack-tools
      - qemu-kvm-ev
      - qemu-img-ev
