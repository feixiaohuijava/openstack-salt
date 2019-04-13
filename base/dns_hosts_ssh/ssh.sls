# saltstack, * except saltstack

{% set ip = salt['network.interface_ip']('eth0') %}
{% set project_path = pillar['openstack_cluster_info']['salt_master_path'] %}

{% if ip == pillar['openstack_cluster_info']['saltstack'] ['ip'] %}
cp_roster_to_etc_salt:
   file.managed:
      - name: /etc/salt/roster
      - source: salt://dns_hosts_ssh/files/roster

generate_known_hosts:
   cmd.run:
      - name: salt-ssh '*' test.ping -i

#这步操作如果know_hosts是要被清空的
cp_known_hosts_to_saltstack_template:
   cmd.run:
      - name: /bin/cp -f /root/.ssh/known_hosts {{ project_path }}/dns_hosts_ssh/files

{% endif %}





# cp all files to all of minions
cp_authorized_keys:
   file.managed:
      - name: /root/.ssh/authorized_keys
      - source: salt://dns_hosts_ssh/files/authorized_keys

cp_id_rsa:
   file.managed:
      - name: /root/.ssh/id_rsa
      - source: salt://dns_hosts_ssh/files/id_rsa

cp_id_rsa_pub:
   file.managed:
      - name: /root/.ssh/id_rsa.pub
      - source: salt://dns_hosts_ssh/files/id_rsa.pub

cp_known_hosts:
   file.managed:
      - name: /root/.ssh/known_hosts
      - source: salt://dns_hosts_ssh/files/known_hosts

chmod_root_.ssh:
   cmd.run:
       - name: |
           chmod 700 /root/.ssh
           chmod 600 /root/.ssh/id_rsa
           chmod 600 /root/.ssh/authorized_keys
           chmod 644 /root/.ssh/id_rsa.pub
           chmod 644 /root/.ssh/known_hosts


