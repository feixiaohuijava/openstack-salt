base:
  'controller01':
     - packages.basic_soft
     - hosts.dns
     - hosts.hosts
     - hosts.ssh
     - firewalld.firewallnetwork
     - firewalld.selinux
  'controller02':
     - packages.basic_soft
     - hosts.dns
     - hosts.hosts
     - hosts.ssh
     - firewalld.firewallnetwork
     - firewalld.selinux
  'controller03':
     - packages.basic_soft
     - hosts.dns
     - hosts.hosts
     - hosts.ssh
     - firewalld.firewallnetwork
     - firewalld.selinux
  'controller01':
     - chrony.service
  'controller02':
     - chrony.service
  'controller03':
     - chrony.service


#  'test01':
#    - openstack.keystone.service
#    - keystone.service
