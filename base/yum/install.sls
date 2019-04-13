openstack_installed:
  file.managed:
    - name: /etc/yum.repos.d/openstack.repo
    - source: salt://openstack/files/openstack.repo
    - template: jinja
    - defaults:
      baseurl: {{ pillar['yum']['info']['baseurl'] }}
      gpgcheck: {{ pillar['yum']['info']['gpgcheck'] }}
      enable: {{ pillar['yum']['info']['enable'] }}
      keepcache: {{ pillar['yum']['info']['keepcache'] }}

  cmd.run:
    - name: rm -rf /etc/yum.repos.d/*.repo
    - name: yum clean all
    - name: yum makecache
  pkg.installed:
    - pkgs:
      - python2-openstackclient
      - openstack-selinux
