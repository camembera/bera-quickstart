#!/bin/bash

set -e
. ./env.sh

if [ -f "seed-data/el-peers.txt" ]; then
    export EL_PEERS=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
fi

export ARCHIVE_OPTION="--full"
if [ "$CL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION=""
fi

$RETH_BIN node $ARCHIVE_OPTION \
--authrpc.addr 0.0.0.0 \
--authrpc.port $EL_AUTHRPC_PORT \
--authrpc.jwtsecret $JWT_PATH \
--chain $RETH_GENESIS_PATH \
--datadir $RETH_DATA \
--port 30303 \
--http \
--http.addr 0.0.0.0 \
--http.port 8545 \
--http.corsdomain '*' \
--http.api admin,debug,eth,net,trace,txpool,web3,rpc,reth,ots,flashbots,miner \
--bootnodes $EL_PEERS \
--trusted-peers $EL_PEERS \
--ws \
--ws.addr 0.0.0.0 \
--ws.port 8546 \
--ws.origins '*' \
--log.file.directory $LOG_DIR ;
