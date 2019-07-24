NAME=okan

# /////////////////////////////////////////////////////////////////////////////

bootstrap:
	cfy install openstack.yaml -b ${NAME}

uninstall:
	cfy uninstall ${NAME} -p ignore_failure=true

output:
	cfy deployment outputs playbox

# # //////////////////////////////////////////////////////////////////////////////
#
# bootstrap_cluster:
# 	cfy install openstack.yaml \
# 		-b playbox_cluster \
# 		-i server_name=playbox \
# 		-i resource_count=3
#
# uninstall_cluster:
# 	cfy uninstall playbox_cluster -p ignore_failure=true
#
# # //////////////////////////////////////////////////////////////////////////////
#
# debug:
# 	cfy install debug.yaml \
# 		-b debug \
# 		-i server_name=playbox
#
# debug_uninstall:
# 	cfy uninstall debug -p ignore_failure=true
#
# # //////////////////////////////////////////////////////////////////////////////
#
# cancel_install:
# 	cfy exec cancel `cfy exec li -d playbox | grep "started " | cut -d'|' -f2`
