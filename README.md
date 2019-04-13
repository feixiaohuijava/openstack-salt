# salt_openstack

- 使用Saltstack自动部署Openstack集群。

##使用步骤

**1.下载SLS和源码安装包** 

```
 git clone https://github.com/valor7/salt_openstack.git

```
**2.修改salt-master配置主目录**
```
##指定file_roots和pillar_roots ,按实际情况来，替换为你的base和pillar目录实际存放路径
vim /etc/salt/master
file_roots:
  base:
    - /root/salt_openstack/base
pillar_roots:
  base:
    - /root/salt_openstack/pillar
```

**2.修改Pillar目录的各个服务的配置**
主要修改相应密码，yum源，ip等
**3.修改top.sls**
```
##一个控制节点，一个计算节点的配置方法
##server1为控制节点，server2为计算节点

vim salt_openstack/base/top.sls

base:
  'server1':
    - ntp.service
    - openstack.install
    - sql.init
    - rabbitmq.service
    - memcached.service
    - keystone.service
    - service_entity.service
    - glance.service
    - nova.services
    - neutron.services
    - dashboard.service
  'server2':
    - ntp.service
    - comput_node.service

```
