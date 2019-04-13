shutdown_selinux:
     cmd.run:
        - name: |
           getenforce
           sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
           cat /etc/sysconfig/selinux
           setenforce 0
           getenforce