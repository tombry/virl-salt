{% set publicport = salt['pillar.get']('virl:public_port', salt['grains.get']('public_port', 'eth0')) %}

include:
  - common.salt-master.cluster-config

salt-master config:
  file.managed:
    - name: /etc/salt/master.d/cluster.conf
    - source: salt://common/salt-master/files/cluster.conf.jinja
    - makedirs: true
    - template: jinja

port block salt-master:
  file.blockreplace:
    - name: /etc/rc.local
    - marker_start: "# 004s"
    - marker_end: "# 004e"
    - content: |
             /sbin/iptables -A INPUT -p tcp --dport 4505:4506 -i {{ publicport }} -j DROP

/srv/salt:
  file.directory:
    - makedirs: true

/srv/pillar:
  file.directory:
    - makedirs: true

salt-master restarting for config:
  service.running:
    - name: salt-master
    - watch:
      - file: salt-master config
