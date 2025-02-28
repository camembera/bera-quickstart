#!/bin/bash -x

set -e
. ./env.sh


PEERS_OPTION=""
if [ -f "seed-data/el-peers.txt" ]; then
    EL_PEERS=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
    PEERS_OPTION="--trusted-peers $EL_PEERS"
fi

BOOTNODES_OPTION=""
if [ -f "seed-data/el-bootnodes.txt" ]; then
    EL_BOOTNODES=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
    BOOTNODES_OPTION="--bootnodes $EL_BOOTNODES"
fi

ARCHIVE_OPTION=""
if [ "$EL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION="--gcmode archive"
fi

export ARCHIVE_OPTION="--full"
if [ "$EL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION=""
fi

IP_OPTION=""
if [ -n "$MY_IPV4" ]; then
    IP_OPTION="--nat extip:$MY_IPV4"
fi

$RETH_BIN node 					\
	--datadir $RETH_DATA			\
	--chain $RETH_GENESIS_PATH		\
	$ARCHIVE_OPTION				\
        $BOOTNODES_OPTION			\
	$PEERS_OPTION				\
	$IP_OPTION				\
	--authrpc.addr 127.0.0.1		\
	--authrpc.port $EL_AUTHRPC_PORT		\
	--authrpc.jwtsecret $JWT_PATH		\
	--port $CL_ETH_PORT			\
	--http					\
	--http.addr 0.0.0.0			\
	--http.port $CL_ETHRPC_PORT		\
        --ipcpath /tmp/reth.ipc.$EL_ETHRPC_PORT \
        --discovery.port $CL_ETHRPC_PORT	\
	--http.corsdomain '*'			\
	--log.file.directory $LOG_DIR		\
	--engine.persistence-threshold 0	\
	--engine.memory-block-buffer-target 0 
