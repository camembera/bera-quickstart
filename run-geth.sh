#!/bin/bash

set -e
. ./env.sh

BOOTNODES_OPTION=""
if [ -f "seed-data/el-bootnodes.txt" ]; then
    EL_BOOTNODES=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
    BOOTNODES_OPTION="--bootnodes $EL_BOOTNODES"
fi

ARCHIVE_OPTION=""
if [ "$EL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION="--gcmode archive"
fi

IP_OPTION=""
if [ -n "$MY_IPV4" ]; then
    IP_OPTION="--nat extip:$MY_IPV4"
fi

$GETH_BIN 				\
	--datadir $GETH_DATA		\
	--syncmode full			\
	--ipcpath /tmp/geth.ipc		\
	$BOOTNODES_OPTION		\
	$ARCHIVE_OPTION			\
	$IP_OPTION			\
	--http				\
	--http.addr 0.0.0.0		\
	--http.port $CL_ETHRPC_PORT	\
	--port $CL_ETH_PORT		\
	--authrpc.addr 127.0.0.1	\
	--authrpc.port $EL_AUTHRPC_PORT	\
	--authrpc.jwtsecret $JWT_PATH	\
	--authrpc.vhosts localhost

