#!/bin/bash
cat /root/scripts/hosts>>/etc/hosts
for name in $(tail -n+8 /etc/hosts|cut -d' ' -f2); do
scp /etc/hosts ${name}:/etc/hosts
done
