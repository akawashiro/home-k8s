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
ssh vagrant@192.168.11.71 date
ssh vagrant@192.168.11.72 date
ssh vagrant@192.168.11.73 date
ansible-playbook cluster-construction.yaml -i hosts -vvvv
