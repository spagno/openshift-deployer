#!/bin/bash
cd /usr/share/ansible/openshift-ansible/playbooks
if [ -z ${PLAYBOOK} ]
then
   echo "No playbook defined"
   exit 1
fi
ansible-playbook ${PLAYBOOK} -vv
