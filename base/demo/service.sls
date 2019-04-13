
{% set ip = ['a','b','c'] %}
{% if 'a' in ip %}
demo:
  cmd.run:
     - name: echo "hello"
{% endif %}
