#!/bin/bash
cat /root/hosts>>/etc/hosts
tail -n+8 /etc/hosts|scp /etc/hosts root@$(cut -d' ' -f3):/etc/hosts
