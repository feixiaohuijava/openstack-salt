
# controller*

include:
  - mariadb.install




mariadb_service:
  service.running:
    - name: mariadb
    - enable: True