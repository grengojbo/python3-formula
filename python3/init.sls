{% if pillar.get('python3', {}).get('install_from_source') %}
  - python3.source
{% else %}
  - python3.package
{% endif -%}