#!/bin/bash -eux

if [ $(vagrant snapshot list --machine-readable | grep savepoint | wc -l) != "3" ]
then
    vagrant destroy -f
    vagrant up
    vagrant halt
    vagrant snapshot save savepoint
    vagrant snapshot list
    vagrant snapshot restore savepoint
else
    vagrant halt
    vagrant snapshot restore savepoint
fi

rm -rf join-command
mkdir join-command

IPS=(192.168.11.71 192.168.11.72 192.168.11.73)
for IP in ${IPS[@]}; do
    ping -c 5 $IP
done

ansible-playbook cluster-construction.yaml -i hosts -v
sshpass -p "vagrant" scp vagrant@192.168.11.71:~/.kube/config ~/.kube/config
