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

$GETH_BIN 				\
	--datadir $GETH_DATA		\
	--syncmode full			\
	--ipcpath /tmp/geth.ipc		\
	$BOOTNODES_OPTION		\
	$ARCHIVE_OPTION			\
	--http				\
	--http.addr 0.0.0.0		\
	--http.api eth,net		\
	--authrpc.addr 127.0.0.1	\
	--authrpc.port $EL_AUTHRPC_PORT	\
	--authrpc.jwtsecret $JWT_PATH	\
	--authrpc.vhosts localhost

