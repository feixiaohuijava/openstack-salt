haproxy_install:
  pkg.installed:
    - pkgs:
      - haproxy
      - xinetd