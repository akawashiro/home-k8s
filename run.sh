#!/bin/bash -eux
vagrant destroy -f
vagrant up
ssh vagrant@192.168.11.71 date
ssh vagrant@192.168.11.72 date
ssh vagrant@192.168.11.73 date
ansible-playbook cluster-construction.yaml -i hosts -vvvv
scp vagrant@192.168.11.71:~/token .
