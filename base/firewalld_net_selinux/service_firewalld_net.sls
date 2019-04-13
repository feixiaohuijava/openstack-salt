
# if minion firewalld was open, salt-master can't remote operation its minion
firewalld_dead:
    service.dead:
       - name: firewalld

firewalld_disabled:
    service.disabled:
       - name: firewalld


NetworkManager_dead:
    service.dead:
       - name: NetworkManager

NetworkManager_disabled:
    service.disabled:
       - name: NetworkManager


network_service_running:
   service.running:
     - name: network
     - enable: True