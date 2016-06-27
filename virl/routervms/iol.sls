{% set iol = salt['pillar.get']('lxcimages:iol', False) %}
{% set iolpref = salt['pillar.get']('virl:iol', salt['grains.get']('iol', True)) %}

include:
  - virl.routervms.virl-core-sync

{% if iol and iolpref %}

iol:
  virl_core.lxc_image_present:
  - subtype: IOL
  - release: high_iron_010416

{% else %}

iol gone:
  virl_core.lxc_image_absent:
  - subtype: IOL

{% endif %}