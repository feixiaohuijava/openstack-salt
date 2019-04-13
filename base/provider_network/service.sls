
cp_ifcfg-eth0:
   file.managed:
      - name: /etc/sysconfig/network-scripts/ifcfg-eth1
      - source: salt://provider_network/files/ifcfg-eth1

cmd_ifcfg:
   cmd.run:
      - name: ifup eth1