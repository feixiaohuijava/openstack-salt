databases: 
  root:
    password: "redhat"
  openstack:
    password: "openstack"
  nova: 
    db_name: "nova"
    username: "nova"
    password: "nova"
    service: "nova-api"
    db_sync: "nova-manage db sync"
  keystone: 
    db_name: "keystone"
    username: "keystone"
    password: "openstack"
    service: "keystone"
    db_sync: "keystone-manage db_sync"
  cinder: 
    db_name: "cinder"
    username: "cinder"
    password: "cinder"
    service: "cinder"
    db_sync: "cinder-manage db sync"
  glance: 
    db_name: "glance"
    username: "glance"
    password: "glance"
    service: "glance"
    db_sync: "glance-manage db_sync"
  neutron: 
    db_name: "neutron"
    username: "neutron"
    password: "neutron"
