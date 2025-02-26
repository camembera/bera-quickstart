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

$RETH_BIN node $ARCHIVE_OPTION			\
	--authrpc.addr 127.0.0.1		\
	--authrpc.port $EL_AUTHRPC_PORT		\
	--authrpc.jwtsecret $JWT_PATH		\
	--chain $RETH_GENESIS_PATH		\
	--datadir $RETH_DATA			\
	--port 30303				\
	--http					\
	--http.addr 0.0.0.0			\
	--http.port 8545			\
	--http.corsdomain '*'			\
	--trusted-peers $EL_PEERS		\
	--log.file.directory $LOG_DIR		\
	--engine.persistence-threshold 0	\
	--engine.memory-block-buffer-target 0 
