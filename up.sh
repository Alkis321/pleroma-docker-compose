#! /bin/bash -i

export User="debian"
export inventory="workers"
export inventoryfile="inventory"
export YAML="prepare.yml"
export ANSIBLE_HOST_KEY_CHECKING=False

ANSIBLE_HOST_KEY_CHECKING=False \
ansibleplaybook ${YAML} -i ${inventoryfile}   -f 5  -u ${User}  \
--private-key=/keys/fedlab \
-e ansible_python_interpreter=/usr/bin/python3 \
--extra-vars "username=${User} inv=${inventory}" \
--ssh-common-args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'