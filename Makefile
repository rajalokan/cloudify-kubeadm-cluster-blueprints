NAME=k8scluster

# /////////////////////////////////////////////////////////////////////////////

bootstrap:
	cfy install openstack.yaml -b ${NAME}

uninstall:
	cfy uninstall ${NAME} -p ignore_failure=true

output:
	cfy deployment outputs playbox

# //////////////////////////////////////////////////////////////////////////////

cancel_install:
	cfy exec cancel `cfy exec li -d ${NAME} | grep "started " | cut -d'|' -f2`
