# controller01, controller02/03

{% set ip = salt['network.interface_ip']('eth0') %}

{% set cluster_ip = pillar['openstack_cluster_info']['cluster_ip']['ip'] %}

cp_admin_openrc:
   file.managed:
     - name : /root/admin-openrc
     - source: salt://openstack/keystone/files/admin-openrc
     - template: jinja
     - defaults:
        cluster_ip: {{ cluster_ip }}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
create_keystone_service:
    cmd.run:
      - name: keystone-manage bootstrap --bootstrap-password openstack --bootstrap-username admin --bootstrap-project-name admin --bootstrap-role-name admin --bootstrap-service-name keystone --bootstrap-region-id RegionOne --bootstrap-admin-url http://{{ cluster_ip }}:35357/v3 --bootstrap-internal-url http://{{ cluster_ip }}:35357/v3 --bootstrap-public-url http://{{ cluster_ip }}:5000/v3

# the number of sleep was suspected
wait_create_keystone_service:
    cmd.run:
      - name: sleep 5
#it will be wrong if name replace names
verification_keystone_service:
   cmd.run:
     - names:
         - openstack project list --os-username admin --os-project-name admin --os-user-domain-id default --os-project-domain-id default --os-identity-api-version 3 --os-auth-url http://{{ cluster_ip }}:5000 --os-password openstack

create_service_demo_user:
   cmd.run:
     - name: |
        source /root/admin-openrc
        openstack project create --domain default --description 'Service Project' service
        openstack project create --domain default  service
        openstack role create user
        openstack project create --domain default --description 'Demo Project' demo
        openstack user create --domain default --password demo demo
        openstack role add --project demo --user demo user
        openstack domain list
        openstack project list
        openstack role list
        openstack user list

verification_get_token:
   cmd.run:
     - name: |
         source /root/admin-openrc
         unset OS_TOKEN OS_URL
         openstack --os-auth-url http://{{ cluster_ip }}:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin token issue --os-password openstack
         openstack --os-auth-url http://{{ cluster_ip }}:5000/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name demo --os-username demo token issue --os-password demo

{% endif %}




verification_admin_openrc:
   cmd.run:
     - name: |
         source /root/admin-openrc
         openstack token issue
         openstack endpoint list
         openstack token issue