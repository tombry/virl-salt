{% for each in 'ank','files','images','std','vmm' %}
/srv/virl/{{ each }}:
  file.recurse:
    - source: 'salt://{{each}}/'
    - order: 1
    - clean: True
    - user: virl
    - makedirs: True
    - group: virl
    - file_mode: 755
    - include_empty: True

{% endfor %}
