ceph_install:
  pkg.installed:
    - pkgs:
      - ceph
      - python-rbd
      - ceph-common