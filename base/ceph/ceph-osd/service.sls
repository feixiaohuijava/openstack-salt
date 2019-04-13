{% set ip = salt['network.interface_ip']('eth0') %}
partition_journal_log_disk:
   cmd.run:
      - name: |
         parted /dev/sdc mklabel gpt
         parted /dev/sdc mkpart primary 0 10%
         parted /dev/sdc mkpart primary  10% 20%
         parted /dev/sdc mkpart primary   20% 30%

update_disk_type:
   cmd.run:
      - name: fdisk /dev/sdc

ceph_osd:
   cmd.run:
      - name: |
         ceph-deploy osd create  ceph01 --filestore  --data /dev/sdb   --journal   /dev/sdc1
         ceph-deploy osd create  ceph01 --filestore  --data /dev/sde   --journal   /dev/sdc2

ceph_osd_test:
   cmd.run:
      - name: |
          ceph -s
          ceph osd tree

{% if ip == pillar['openstack_cluster_info']['ceph01']['ip'] %}
create_osd_pool:
   cmd.run:
      - name: |
          ceph osd pool create images 128
          ceph osd pool create vms 128
          ceph osd pool create volumes 128
          ceph osd pool create backups 128

test_osd_pool:
    cmd.run:
       - name: |
          ceph -s
          ceph osd tree
          ceph osd lspools

{% endif %}
