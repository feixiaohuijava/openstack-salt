{% set ip = salt['network.interface_ip']('eth0') %}
{% set controller01 = pillar['openstack_cluster_info']['controller01']['ip'] %}
{% set controller02 = pillar['openstack_cluster_info']['controller02']['ip'] %}
{% set controller03 = pillar['openstack_cluster_info']['controller03']['ip'] %}
{% set ceph01 = pillar['openstack_cluster_info']['ceph01']['ip'] %}
{% set ceph02 = pillar['openstack_cluster_info']['ceph02']['ip'] %}

{% if ip == pillar['openstack_cluster_info']['controller01']['ip'] %}
authorization_ceph_to_glance:
    cmd.run:
        - name: |
            ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images' -o /etc/ceph/client.glance.keyring
            chown glance.glance /etc/ceph/client.glance.keyring
            ceph auth list
            rbd ls images -k /etc/ceph/client.glance.keyring --id glance
            scp -p client.glance.keyring root@controller2:/etc/ceph/client.glance.keyring
            scp -p client.glance.keyring root@controller3:/etc/ceph/client.glance.keyring
            scp -p client.glance.keyring root@compute1:/etc/ceph/client.glance.keyring
            scp -p client.glance.keyring root@compute2:/etc/ceph/client.glance.keyring
{% endif %}

{% if ip in [controller02,controller03,ceph01,ceph02] %}
chown_glance.keyring:
    cmd.run:
         - name: chown glance.glance /etc/ceph/client.glance.keyring

{% endif %}

{% if ip in [controller01,controller02,controller03,ceph01,ceph02] %}

{% endif %}
