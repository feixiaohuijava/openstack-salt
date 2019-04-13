service_entity:
  cmd.run:
    - name: /etc/init.d/script service_entity_and_API_prerequisites_domain_projects_users_roles

admin-openrc:
  file.managed:
    - name: /root/admin-openrc
    - source: salt://service_entity/files/admin-openrc
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      admin_passwd: {{ pillar['user_info']['admin']['admin_passwd'] }}


demo-openrc:
  file.managed:
    - name: /root/demo-openrc
    - source: salt://service_entity/files/demo-openrc
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      demo_passwd: {{ pillar['user_info']['demo']['demo_passwd'] }}

