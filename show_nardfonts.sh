#/bin/sh
for i in {57344..62790}; do echo -n -e "$(printf '\\u%x ' $i)"; done
