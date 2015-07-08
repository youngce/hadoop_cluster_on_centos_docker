#!/bin/bash
cat /root/hosts_cmds/hosts>>/etc/hosts
for name in $(tail -n+8 /etc/hosts|cut -d' ' -f3); do
  scp /etc/hosts ${name}:/etc/hosts
done
