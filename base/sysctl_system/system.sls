opertimization_system:
  cmd.run:
    - name: |
       echo "DefaultLimitNOFILE=1024000" >> /etc/systemd/system.conf
       echo "DefaultLimitNPROC=1024000" >> /etc/systemd/system.conf

opertimization_handle:
  cmd.run:
    - name: |
       echo "* soft nofile 655350" >> /etc/security/limits.conf
       echo "* hard nofile 655350" >> /etc/security/limits.conf
       echo "* soft core unlimited" >> /etc/security/limits.conf
       echo "* hard core unlimited" >> /etc/security/limits.conf
       cat /etc/security/limits.conf

chrony_sources:
  cmd.run:
     - name: chronyc sources