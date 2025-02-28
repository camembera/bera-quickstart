#!/bin/bash

set -e
. ./env.sh

if [ ! -x "$NETHERMIND_BIN" ]; then
    echo "Error: Nethermind executable $NETHERMIND_BIN does not exist or is not executable"
    exit 1
fi

mkdir -p $NETHERMIND_DATA_DIR
mkdir -p $NETHERMIND_CONFIG_DIR

echo NETHERMIND_CONFIG_DIR: $NETHERMIND_CONFIG_DIR
echo NETHERMIND_DATA_DIR: $NETHERMIND_DATA_DIR
echo NETHERMIND_BIN: $NETHERMIND_BIN
echo "  Version: $($NETHERMIND_BIN --version | grep Version)"

cp seed-data/eth-nether-genesis.json $NETHERMIND_GENESIS_PATH

PEERS_LINE=""
if [ -f "seed-data/el-peers.txt" ]; then
    EL_PEERS=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
    PEERS_LINE=", \"TrustedPeers\":  \"$EL_PEERS\""
fi

BOOTNODES_LINE=""
if [ -f "seed-data/el-bootnodes.txt" ]; then
    EL_BOOTNODES=$(grep '^enode://' "seed-data/el-peers.txt"| tr '\n' ',' | sed 's/,$//')
    BOOTNODES_LINE=", \"Bootnodes\":  \"$EL_BOOTNODES\""
fi

ARCHIVE_OPTION=' , "Pruning": { "Mode": "Full" } '
if [ "$EL_ARCHIVE_NODE" = true ]; then
    ARCHIVE_OPTION=' ,  "Pruning": { "Mode": "None" } '
fi

IP_OPTION=""
if [ -n "$MY_IPV4" ]; then
    IP_OPTION=", \"ExternalIp\": \"$MY_IPV4\""
fi

cat <<EOF > $NETHERMIND_CONFIG_DIR/nethermind.cfg
{
  "Init": {
    "MemoryHint": 768000000,
    "ChainSpecPath": "$NETHERMIND_GENESIS_PATH",
    "BaseDbPath": "$NETHERMIND_DATA_DIR",
    "LogDirectory": "$LOG_DIR",
    "LogFileName": "nethermind.log"
  },
  "JsonRpc": {
    "Enabled": true,
    "Port": $EL_ETHRPC_PORT,
    "Host": "0.0.0.0",
    "EnabledModules": "net,eth,subscribe,engine,web3,client",
    "EnginePort": $EL_AUTHRPC_PORT,
    "EngineHost": "127.0.0.1",
    "EngineEnabledModules": "net,eth,subscribe,engine,web3,client",
    "JwtSecretFile": "$JWT_PATH"
  },
  "Sync": {
    "SnapSync": true
  },
  "Network": {
    "P2PPort": $CL_ETH_PORT,
    "DiscoveryPort": $CL_ETH_PORT,
    "EnableUPnP": true
    $IP_OPTION
    $BOOTNODES_LINE
    $PEERS_LINE
  },
  "EthStats": {
    "Enabled": false
  },
  "Metrics": {
    "Enabled": false,
    "NodeName": "Berachain Mainnet"
  }
  $ARCHIVE_OPTION
}
EOF

echo
echo "✓ Nethermind set up."