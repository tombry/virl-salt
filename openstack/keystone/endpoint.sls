{% set ospassword = salt['grains.get']('password', 'password') %}
{% set public_ip = salt['grains.get']('public_ip', '127.0.1.1') %}
{% set ks_token = salt['grains.get']('keystone_service_token', 'fkgjhsdflkjh') %}
{% set uwmpassword = salt['grains.get']('uwmadmin_password', 'password') %}
{% set int_ip = salt['pillar.get']('virl:internalnet_controller_ip', salt['grains.get']('internalnet_controller_ip', '172.16.10.250' )) %}
{% from "virl.jinja" import virl with context %}

include:
  - openstack.keystone.install
  - openstack.keystone.setup

glance endpoint:
  keystone.endpoint_present:
    - name: glance
    - publicurl: http://{{ public_ip }}:9292
    - internalurl: http://{{ int_ip }}:9292
    - adminurl: http://{{ int_ip }}:9292
    - require:
      - cmd: key-db-sync

keystone endpoint:
  keystone.endpoint_present:
    - name: keystone
    - publicurl: http://{{ public_ip }}:5000/{{ virl.keystone_auth_version }}
    - internalurl: http://{{ int_ip }}:5000/{{ virl.keystone_auth_version }}
    - adminurl: http://{{ int_ip }}:35357/{{ virl.keystone_auth_version }}
    - require:
      - cmd: key-db-sync

neutron endpoint:
  keystone.endpoint_present:
    - name: neutron
    - publicurl: http://{{ public_ip }}:9696
    - internalurl: http://{{ int_ip }}:9696
    - adminurl: http://{{ int_ip }}:9696
    - require:
      - cmd: key-db-sync

nova endpoint:
  keystone.endpoint_present:
    - name: nova
    - publicurl: http://{{ public_ip }}:8774/v2/$(tenant_id)s
    - internalurl: http://{{ int_ip }}:8774/v2/$(tenant_id)s
    - adminurl: http://{{ int_ip }}:8774/v2/$(tenant_id)s
    - require:
      - cmd: key-db-sync

{% if virl.mitaka %}
cinder endpoint:
  keystone.endpoint_present:
    - name: cinder
    - publicurl: http://{{ public_ip }}:8776/v2/$(tenant_id)s
    - internalurl: http://{{ int_ip }}:8776/v2/$(tenant_id)s
    - adminurl: http://{{ int_ip }}:8776/v2/$(tenant_id)s
    - require:
      - cmd: key-db-sync
{% endif %}

{% if virl.kilo %}
cinder endpoint:
  keystone.endpoint_present:
    - name: cinder
    - publicurl: http://{{ public_ip }}:8776/v1/$(tenant_id)s
    - internalurl: http://{{ int_ip }}:8776/v1/$(tenant_id)s
    - adminurl: http://{{ int_ip }}:8776/v1/$(tenant_id)s
    - require:
      - cmd: key-db-sync


cinder endpointv2:
  keystone.endpoint_present:
    - name: cinderv2
    - publicurl: http://{{ public_ip }}:8776/v2/$(tenant_id)s
    - internalurl: http://{{ int_ip }}:8776/v2/$(tenant_id)s
    - adminurl: http://{{ int_ip }}:8776/v2/$(tenant_id)s
    - require:
      - cmd: key-db-sync
{% endif %}

orchestration endpoint:
  keystone.endpoint_present:
    - name: heat
    - publicurl: http://{{ public_ip }}:8004/v1/$(tenant_id)s
    - internalurl: http://{{ int_ip }}:8004/v1/$(tenant_id)s
    - adminurl: http://{{ int_ip }}:8004/v1/$(tenant_id)s
    - require:
      - cmd: key-db-sync

cloudformation endpoint:
  keystone.endpoint_present:
    - name: heat-cfn
    - publicurl: http://{{ public_ip }}:8000/v1
    - internalurl: http://{{ int_ip }}:8000/v1
    - adminurl: http://{{ int_ip }}:8000/v1
    - require:
      - cmd: key-db-sync
