#!/bin/sh

chown -R ${USER}:${USER} /home/${USER}/.klei

su -m ${USER} -c " \
./dontstarve_dedicated_server_nullrenderer -persistent_storage_root /home/${USER}/.klei -shard Master < /dev/null &> master.log & \
./dontstarve_dedicated_server_nullrenderer -persistent_storage_root /home/${USER}/.klei -shard Caves < /dev/null &> caves.log & \
tail -f master.log caves.log"