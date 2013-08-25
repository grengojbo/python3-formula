{% from "python3/package-map.jinja" import python3 with context %}

python3:
  pkg.installed:
    - name:
    	- {{ python3.python }}
			- {{ python3.dev }}