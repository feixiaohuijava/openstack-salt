remove_rabbitmq_yum:
      pkg.removed:
         - name: rabbitmq-server

rm_rabbitmq_file:
      cmd.run:
         - name:
             rm -rf /etc/rabbitmq/
             rm -rf /var/lib/rabbitmq/mnesia
