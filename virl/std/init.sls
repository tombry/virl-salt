{% set cml = salt['grains.get']('cml', False) %}
{% set virl_type = salt['grains.get']('virl_type', 'stable') %}
{% set uwmpassword = salt['pillar.get']('virl:uwmadmin_password', salt['grains.get']('uwmadmin_password', 'password')) %}
{% set venv = salt['pillar.get']('behave:environment', 'stable') %}
{% set ks_token = salt['pillar.get']('virl:keystone_service_token', salt['grains.get']('keystone_service_token', 'fkgjhsdflkjh')) %}
{% set http_proxy = salt['pillar.get']('virl:http_proxy', salt['grains.get']('http_proxy', 'https://proxy.esl.cisco.com:80/')) %}
{% set proxy = salt['pillar.get']('virl:proxy', salt['grains.get']('proxy', False)) %}
{% set std_ver_fixed = salt['pillar.get']('behave:std_ver_fixed', salt['grains.get']('std_ver_fixed', False)) %}
{% set ospassword = salt['pillar.get']('virl:password', salt['grains.get']('password', 'password')) %}
{% set stdport = salt['pillar.get']('virl:virl_webservices', salt['grains.get']('virl_webservices', '19399')) %}
{% set std_ver = salt['pillar.get']('behave:std_ver', salt['grains.get']('std_ver', '0.10.10.18')) %}
{% set uwmport = salt['pillar.get']('virl:virl_user_management', salt['grains.get']('virl_user_management', '19400')) %}
{% set cinder_enabled = salt['pillar.get']('virl:cinder_enabled', salt['grains.get']('cinder_enabled', False)) %}
{% set masterless = salt['pillar.get']('virl:salt_masterless', salt['grains.get']('salt_masterless', false)) %}
{% set venv = salt['pillar.get']('behave:environment', 'stable') %}
{% set serstart = salt['pillar.get']('virl:start_of_serial_port_range', salt['grains.get']('start_of_serial_port_range', '17000')) %}
{% set serend = salt['pillar.get']('virl:end_of_serial_port_range', salt['grains.get']('end_of_serial_port_range', '18000')) %}
{% set ank_live = salt['pillar.get']('virl:ank_live', salt['grains.get']('ank_live', '19402')) %}
{% set virl_webmux = salt['pillar.get']('virl:virl_webmux', salt['grains.get']('virl_webmux', '19403')) %}
{% set topology_editor_port = salt['pillar.get']('virl:ank', salt['grains.get']('ank', '19401')) %}
{% set web_editor = salt['pillar.get']('virl:web_editor', salt['grains.get']('web_editor', False)) %}
{% set fdns = salt['pillar.get']('virl:first_nameserver', salt['grains.get']('first_nameserver', '8.8.8.8' )) %}
{% set sdns = salt['pillar.get']('virl:second_nameserver', salt['grains.get']('second_nameserver', '8.8.4.4' )) %}
{% set kilo = salt['pillar.get']('virl:kilo', salt['grains.get']('kilo', true)) %}
{% set ram_overcommit = salt['pillar.get']('virl:ram_overcommit', salt['grains.get']('ram_overcommit', '2')) %}
{% set cpu_overcommit = salt['pillar.get']('virl:cpu_overcommit', salt['grains.get']('cpu_overcommit', '3')) %}
{% set cluster = salt['pillar.get']('virl:virl_cluster', salt['grains.get']('virl_cluster', False )) %}
{% set compute2_active = salt['pillar.get']('virl:compute2_active', salt['grains.get']('compute2_active', False )) %}
{% set compute3_active = salt['pillar.get']('virl:compute3_active', salt['grains.get']('compute3_active', False )) %}
{% set compute4_active = salt['pillar.get']('virl:compute4_active', salt['grains.get']('compute4_active', False )) %}
{% set compute1 = salt['grains.get']('compute1_hostname', 'compute1' ) %}
{% set compute2 = salt['grains.get']('compute2_hostname', 'compute2' ) %}
{% set compute3 = salt['grains.get']('compute3_hostname', 'compute3' ) %}
{% set compute4 = salt['grains.get']('compute4_hostname', 'compute4' ) %}
{% set download_proxy = salt['pillar.get']('virl:download_proxy', salt['grains.get']('download_proxy', '')) %}
{% set download_no_proxy = salt['pillar.get']('virl:download_no_proxy', salt['grains.get']('download_no_proxy', '')) %}
{% set download_proxy_user = salt['pillar.get']('virl:download_proxy_user', salt['grains.get']('download_proxy_user', '')) %}
{% set host_simulation_port_min_tcp = salt['pillar.get']('virl:host_simulation_port_min_tcp', salt['grains.get']('host_simulation_port_min_tcp', '10000')) %}
{% set host_simulation_port_max_tcp = salt['pillar.get']('virl:host_simulation_port_max_tcp', salt['grains.get']('host_simulation_port_max_tcp', '17000')) %}

include:
  - .clients
  - common.ifb
  - virl.std.tap-counter

std prereq pkgs:
  pkg.installed:
      - pkgs:
        - libxml2-dev
        - libxslt1-dev
        - libc6:i386

/var/cache/virl/std:
  file.recurse:
    {% if std_ver_fixed %}
    - name: /var/cache/virl/fixed/std
    - source: "salt://fixed/std"
    {% else %}
      {% if cml %}
    - source: "salt://cml/std/{{venv}}/"
    - name: /var/cache/virl/std
      {% else %}
    - source: "salt://std/{{venv}}/"
    - name: /var/cache/virl/std
      {% endif %}
    {% endif %}
    - clean: true
    - show_diff: False
    - user: virl
    - group: virl
    - file_mode: 755


uwm_init:
  file.managed:
    - name: /etc/init.d/virl-uwm
    - source: "salt://virl/std/files/virl-uwm.init"
    - mode: 0755

std_init:
  file.managed:
    - name: /etc/init.d/virl-std
    - source: "salt://virl/std/files/virl-std.init"
    - mode: 0755

{% if not cml %}

std doc cleaner:
  file.directory:
    - name: /var/www/doc
    - clean: True

{% endif %}

std docs:
  archive.extracted:
    - name: /var/www/doc/
    {% if cml %}
    - source: "salt://cml/std/{{venv}}/doc/html_ext.tar.gz"
    {% else %}
    - source: "salt://std/{{venv}}/doc/html_ext.tar.gz"
    {% endif %}
    - archive_format: tar
    - if_missing: /var/www/doc/index.html
{% if not cml %}
    - require:
      - file: std doc cleaner
{% endif %}

std docs redo:
  archive.extracted:
    - name: /var/www/doc/
    {% if cml %}
    - source: "salt://cml/std/{{venv}}/doc/html_ext.tar.gz"
    {% else %}
    - source: "salt://std/{{venv}}/doc/html_ext.tar.gz"
    {% endif %}
    - archive_format: tar
    - if_missing: /var/www/doc/index.html
    - onfail: 
      - archive: std docs

virl_webmux_init:
  file.managed:
    - name: /etc/init/virl-webmux.conf
    - source: "salt://virl/std/files/virl-webmux.conf"
    - mode: 0755

std_prereq_webmux:
  pip.installed:
  {% if proxy == true %}
    - proxy: {{ http_proxy }}
  {% endif %}
    - require:
      - pkg: std prereq pkgs
    - names:
      - Twisted >= 13.2.0
      - parse >= 1.4.1
      - stuf >= 0.9.4
      - txsockjs >= 1.2.1
      - zope.interface >= 4.1.0
      - SQLObject >= 1.5.1
      - service_identity
      - docker-py >= 1.3.1
      - lxml >= 3.4.1, < 3.6.0

/etc/virl directory:
  file.directory:
    - name: /etc/virl
    - dir_mode: 755

/etc/virl/common.cfg:
  file.touch:
    - require:
      - file: /etc/virl directory
    - onlyif: 'test ! -e /etc/virl/common.cfg'


/etc/virl/virl.cfg:
  file.managed:
    - replace: false
    - makedirs: true
    - mode: 0644


/etc/rc2.d/S98virl-std:
  file.symlink:
    - target: /etc/init.d/virl-std
    - mode: 0755

/etc/rc2.d/S98virl-uwm:
  file.symlink:
    - target: /etc/init.d/virl-uwm
    - mode: 0755

std uwm port replace:
  file.replace:
      - name: /var/www/html/index.html
      - pattern: :\d{2,}"
      - repl: :{{ uwmport }}"
      - unless: grep {{ uwmport }} /var/www/html/index.html

std nova-compute serial:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: 'serial_console'
    - parameter: 'port_range'
    - value: '{{ serstart }}:{{ serend }}'


std_prereq:
  pip.installed:
{% if proxy == true %}
    - proxy: {{ http_proxy }}
{% endif %}
    - names:
      - docker-py >= 1.3.1
      - ipaddr >= 2.1.11
      - flask-sqlalchemy >= 2.0
      - Flask >= 0.10.1
      - Flask_Login >= 0.3.0
      - Flask_RESTful >= 0.3.2
      - Flask_WTF >= 0.11
      - Flask_Breadcrumbs >= 0.3.0
      - flask-compress
      - itsdangerous >= 0.24
      - Jinja2 >= 2.7.3
      - lxml >= 3.4.1, < 3.6.0
      - MarkupSafe >= 0.23
      - mock >= 1.0.1
      - paramiko >= 1.15.2, < 2.0.0
      - pycrypto >= 2.6.1
      - Pygments
      - requests == 2.7.0
      - redis >= 2.10.5
      - simplejson >= 3.6.5
      - sqlalchemy == 0.9.9
      - websocket_client >= 0.26.0
      - Werkzeug >= 0.10.1
      - wsgiref
      - WTForms >= 2.0.2
      - WTForms-JSON >= 0.2.10
      - tornado >= 3.2.2
      - require:
        - pkg: 'std prereq pkgs'

VIRL_CORE_dead:
  service.dead:
    - names:
      - virl-std
      - virl-uwm
    - prereq:
      - pip: VIRL_CORE
    - require:
      - file: /etc/rc2.d/S98virl-std
      - file: /etc/rc2.d/S98virl-uwm

VIRL_CORE:
  pip.installed:
    - use_wheel: True
    - no_index: True
    - pre_releases: True
    - no_deps: True
    {% if cml %}
     {% if std_ver_fixed %}
    - name: CML_CORE  == {{ std_ver }}
    - find_links: "file:///var/cache/virl/fixed/std"
     {% else %}
    - find_links: "file:///var/cache/virl/std"
    - name: CML_CORE
     {% endif %}
    {% else %}
    {% if std_ver_fixed %}
    - name: VIRL_CORE  == {{ std_ver }}
    - find_links: "file:///var/cache/virl/fixed/std"
    {% else %}
    - name: VIRL_CORE
    - find_links: "file:///var/cache/virl/std"
    - upgrade: True
    {% endif %}
    {% endif %}
  cmd.run:
    - names:
     {% if cml %}
      - echo /usr/local/bin/virl_config lsb-links | at now + 1 min
     {% else %}
      - crudini --set /usr/local/lib/python2.7/dist-packages/virl_pkg_data/conf/builtin.cfg orchestration network_security_groups False
      - crudini --set /usr/local/lib/python2.7/dist-packages/virl_pkg_data/conf/builtin.cfg orchestration network_custom_floating_ip True
      - crudini --set /etc/virl/common.cfg orchestration network_security_groups False
      - crudini --set /etc/virl/common.cfg orchestration network_custom_floating_ip True
     {% endif %}
     {% if cinder_enabled %}
      - crudini --set /usr/local/lib/python2.7/dist-packages/virl_pkg_data/conf/builtin.cfg orchestration volume_service True
      - crudini --set /etc/virl/common.cfg orchestration volume_service True
     {% else %}
      - crudini --set /usr/local/lib/python2.7/dist-packages/virl_pkg_data/conf/builtin.cfg orchestration volume_service False
      - crudini --set /etc/virl/common.cfg orchestration volume_service False
     {% endif %}
      - /usr/local/bin/virl_config update --global
      - crudini --set /etc/virl/virl.cfg env virl_openstack_password {{ uwmpassword }}
      - crudini --set /etc/virl/virl.cfg env virl_openstack_service_token {{ ks_token }}
      - crudini --set /etc/virl/virl.cfg env virl_std_port {{ stdport }}
      - crudini --set /etc/virl/virl.cfg env virl_std_url http://localhost:{{ stdport }}
      - crudini --set /etc/virl/virl.cfg env virl_uwm_port {{ uwmport }}
      - crudini --set /etc/virl/virl.cfg env virl_uwm_url http://localhost:{{ uwmport }}
      - crudini --set /etc/virl/virl.cfg env virl_std_user_name uwmadmin
      - crudini --set /etc/virl/virl.cfg env virl_std_password {{ uwmpassword }}
      - crudini --set /etc/virl/virl.cfg 'new-project-networks' snat_net_dns {{ fdns }}
      - crudini --set /etc/virl/virl.cfg 'new-project-networks' snat_net_dns2 {{ sdns }}
      - crudini --set /etc/virl/virl.cfg 'new-project-networks' mgmt_net_dns {{ fdns }}
      - crudini --set /etc/virl/virl.cfg 'new-project-networks' mgmt_net_dns2 {{ sdns }}
      - crudini --set /etc/virl/virl.cfg env virl_webmux_port {{ virl_webmux }}
      - crudini --set /etc/virl/common.cfg host webmux_port {{ virl_webmux }}
      - crudini --set /etc/virl/common.cfg host ank_live_port {{ ank_live }}
      - crudini --set /etc/virl/common.cfg host download_proxy {{ download_proxy }}
      - crudini --set /etc/virl/common.cfg host download_no_proxy {{ download_no_proxy }}
      - crudini --set /etc/virl/common.cfg host download_proxy_user {{ download_proxy_user }}
      - crudini --set /etc/virl/common.cfg limits host_simulation_port_min_tcp {{ host_simulation_port_min_tcp }}
      - crudini --set /etc/virl/common.cfg limits host_simulation_port_max_tcp {{ host_simulation_port_max_tcp }}
      - crudini --set /etc/virl/common.cfg host ram_overcommit {{ ram_overcommit }}
      - crudini --set /etc/virl/common.cfg host cpu_overcommit {{ cpu_overcommit }}

ank_live_port change:
  cmd.run:
    - name: 'crudini --set /etc/virl/common.cfg host ank_live_port {{ ank_live }}'

ank preview port:
  cmd.run:
    - name: 'crudini --set /etc/virl/common.cfg host ank_preview_port {{ topology_editor_port }}'
    - require:
      - pip: VIRL_CORE

web editor alpha:
{% if web_editor %}
  cmd.run:
    - name: 'crudini --set /etc/virl/common.cfg host topology_editor_port {{ topology_editor_port }}'
{% else %}
  file.replace:
    - name: /etc/virl/common.cfg
    - pattern: '^topology_editor_port.*'
    - repl: ''
{% endif %}
    - require:
      - pip: VIRL_CORE

{% if cluster %}
enable cluster in std :
  cmd.run:
    - name: 'crudini --set /etc/virl/common.cfg orchestration cluster_mode True'
    - require:
      - pip: VIRL_CORE

point std at key:
  cmd.run:
    - name: crudini --set /etc/virl/common.cfg cluster ssh_key '~virl/.ssh/id_rsa'
    - onlyif:
      - test -e ~virl/.ssh/id_rsa.pub
      - test -e /etc/virl/common.cfg
    - require:
      - pip: VIRL_CORE

  {% if compute4_active %}

add up to cluster4 to std:
  cmd.run:
    - name: crudini --set /etc/virl/common.cfg cluster computes '{{compute1}},{{compute2}},{{compute3}},{{compute4}}'
    - require:
      - pip: VIRL_CORE

  {% elif compute3_active %}

add up to cluster3 to std:
  cmd.run:
    - name: crudini --set /etc/virl/common.cfg cluster computes '{{compute1}},{{compute2}},{{compute3}}'
    - require:
      - pip: VIRL_CORE

  {% elif compute2_active %}

add up to cluster2 to std:
  cmd.run:
    - name: crudini --set /etc/virl/common.cfg cluster computes '{{compute1}},{{compute2}}'
    - require:
      - pip: VIRL_CORE

  {% else %}

add only cluster1 to std:
  cmd.run:
    - name: crudini --set /etc/virl/common.cfg cluster computes '{{compute1}}'
    - require:
      - pip: VIRL_CORE

  {% endif %}

{% endif %}

webmux_port change:
  cmd.run:
    - names:
      - crudini --set /etc/virl/virl.cfg env virl_webmux_port {{ virl_webmux }}
      - crudini --set /etc/virl/common.cfg host webmux_port {{ virl_webmux }}
      - service virl-webmux restart

uwmadmin change:
  cmd.run:
    - names:
     {% if cml %}
      - sleep 65
     {% endif %}
      - '/usr/local/bin/virl_uwm_server set-password -u uwmadmin -p {{ uwmpassword }} -P {{ uwmpassword }}'
      - crudini --set /etc/virl/virl.cfg env virl_openstack_password {{ uwmpassword }}
      - crudini --set /etc/virl/virl.cfg env virl_std_password {{ uwmpassword }}
    - onlyif: 'test -e /var/local/virl/servers.db'

virl init:
  cmd:
    - run
    - name: /usr/local/bin/virl_uwm_server init -A http://127.0.1.1:5000/v2.0 -u uwmadmin -p {{ uwmpassword }} -U uwmadmin -P {{ uwmpassword }} -T uwmadmin
    - onlyif: 'test ! -e /var/local/virl/servers.db'

virl init second:
  cmd:
    - run
    - name: /usr/local/bin/virl_uwm_server init -A http://127.0.1.1:5000/v2.0 -u uwmadmin -p {{ uwmpassword }} -U uwmadmin -P {{ uwmpassword }} -T uwmadmin
    - onfail:
      - cmd: uwmadmin change

virl-std:
  service:
    - running
    - order: last
    - enable: True
    - restart: True

virl-uwm:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
