#!/bin/bash 

set -e
. ./env.sh

if [ -f "seed-data/el-peers.txt" ]; then
    export EL_PEERS=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
fi

export ARCHIVE_OPTION=""
if [ "$CL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION="--gcmode archive"
fi

$GETH_BIN $ARCHIVE_OPTION \
	--datadir $GETH_DATA \
	--syncmode full \
	--ipcpath /tmp/geth.ipc \
	--http \
	--http.addr 0.0.0.0 \
	--http.api eth,net \
	--authrpc.addr 127.0.0.1 \
	--authrpc.port $EL_AUTHRPC_PORT \
	--authrpc.jwtsecret $JWT_PATH \
	--authrpc.vhosts localhost
	
