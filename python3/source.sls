{% set python3 = pillar.get('python3', {}) -%}
{% set version = python3.get('version', '3.3.2') -%}
{% set checksum = python3.get('checksum', 'md5=7dffe775f3bea68a44f762a3490e5e28') -%}
{% set source = python3.get('source_root', '/usr/src') -%}

{% set python3_package = '{0}/Python-{1}.tar.bz2'.format(source, version) -%}
{% set python3_home = python3.get('home', '/opt/python3.3') -%}

get-python3:
  pkg.installed:
    - name:
      - build-essential
      - libsqlite3-dev
      - sqlite3
      - bzip2
      - libbz2-dev
  file.managed:
    - name: {{ python3_package }}
    - source: http://python.org/ftp/python/{{ version }}/Python-{{ version }}.tar.bz2
    - source_hash: {{ checksum }}
  cmd.wait:
    - cwd: {{ source }}
    - name: tar jxf {{ python3_package }}
    - watch:
      - file: get-python3

python3:
  cmd.wait:
    - cwd: {{ source }}/Python-{{ version }}
    - names:
      - ./configure --prefix={{ python3_home }}
      - make && make install
    - watch:
      - cmd: get-python3
    - require:
      - cmd: get-python3

get-distribute:
  file.managed:
    - name: distribute_setup.py
    - source: http://python-distribute.org/distribute_setup.py
  cmd.wait:
    - cwd: {{ source }}
    - name: {{ python3_home }}/bin/activate &&  python distribute_setup.py
    - watch:
      - file: get-distribute

/usr/bin/python3:
  file.symlink:
    - target: {{ python3_home }}/bin/python3
    - require:
      - cmd: python3
      - file: {{ python3_home }}

# /usr/bin/pyvenv:
#   file.symlink:
#     - target: {{ python3_home }}/bin/pyvenv
#     - require:
#       - cmd: python3
#       - file: {{ python3_home }}

# get-pip:
#   cmd.wait:
#     - cwd: {{ source }}
#     - name: {{ python3_home }}/bin/activate &&  easy_install pip
#     - require:
#       - file: get-distribute
