{% set hostname = salt['pillar.get']('virl:hostname', salt['grains.get']('hostname', 'virl')) %}
{% set domain = salt['pillar.get']('virl:domain', salt['grains.get']('domain', 'cisco.com')) %}
{% set public_ip = salt['pillar.get']('virl:static_ip', salt['grains.get']('static_ip', '127.0.0.1' )) %}

vhost:
  host.present:
    - name: {{ hostname }}.{{domain}}
    - ip:
      - {{ public_ip }}
      - ::1

vhostloop:
  host.present:
    - name: {{ hostname }}
    - ip:
      - 127.0.1.1
      - ::1

vhostname:
  file.managed:
    - name: /etc/hostname
    - contents: {{ hostname }}
  cmd.wait:
    - name: /usr/bin/hostnamectl set-hostname {{ hostname }}
    - onchanges:
      - file: vhostname
