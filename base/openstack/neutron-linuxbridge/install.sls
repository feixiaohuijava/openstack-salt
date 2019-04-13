node_compute_install:
  pkg.installed:
    - pkgs:
      - openstack-neutron-linuxbridge
      - ebtables
      - ipset
