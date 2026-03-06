#!/bin/bash
make clean
lxc launch ubuntu:24.04 vuln-ssh
lxc exec vuln-ssh -- apt update
lxc exec vuln-ssh -- apt autoremove -y openssh-server
lxc exec vuln-ssh -- apt install -y build-essential autoconf libssl-dev zlib1g-dev
lxc file push -r . vuln-ssh/root/
lxc exec vuln-ssh -- bash -c "cd backdoored-openssh-portable/ && make backdoor && cd openssh-portable-V_10_2_P1/ && make install"
lxc exec vuln-ssh -- /usr/local/sbin/sshd -p 22
IPADDR=$(lxc exec vuln-ssh -- ip a show eth0 | grep -oP '\S+(?=/24)')
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$IPADDR whoami
lxc stop vuln-ssh
lxc delete vuln-ssh