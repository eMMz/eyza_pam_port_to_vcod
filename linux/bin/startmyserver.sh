#!/bin/sh

exec setpriv --reuid=codserver --regid=codserver --clear-groups sh -- <<- 'COD'
	HOME=/data/myserver
	exec env - LD_PRELOAD=$HOME/libcod1.so $HOME/cod_lnxded +set fs_homepath $HOME +set fs_basepath $HOME +set net_port 28960 +exec server_config_1.cfg +map mp_harbor < /dev/tty

COD
