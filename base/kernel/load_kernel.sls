load_kernel:
  cmd.run:
    - name: |
       modprobe bridge
       modprobe nf_conntrack
       modprobe ip_conntrack
       modprobe br_netfilter

effective_system_configuration:
  cmd.run:
    - name: sysctl -p

cp_etc_rc.local:
   file.managed:
       - name: /etc/rc.local
       - source: salt://kernel/files/rc.local

chmod_etc_rc.local:
   cmd.run:
       - name: chmod +x /etc/rc.local



#reboot:
#  cmd.run:
#    - name: salt '*' system.reboot
