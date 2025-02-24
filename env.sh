#!/bin/bash 

set -e

# CHANGE THESE TWO VALUES
export MONIKER_NAME=camembera
export WALLET_ADDRESS_FEE_RECIPIENT=0x9BcaA41DC32627776b1A4D714Eef627E640b3EF5

# CHAIN CONSTANTS
export CHAIN_SPEC="mainnet"
if [ "$CHAIN_SPEC" == "testnet" ]; then
    export CHAIN=testnet-beacon-80069
    export CHAIN_ID=80069
else
    export CHAIN=mainnet-beacon-80094
    export CHAIN_ID=80094
fi
export SEED_DATA_URL=https://raw.githubusercontent.com/berachain/beacon-kit/refs/heads/main/testing/networks/$CHAIN_ID

# THESE DEPEND ON YOUR LOCAL SETUP
export BEACOND_BIN=`/usr/bin/which beacond || echo $(pwd)/beacond`
export BEACOND_DATA=$(pwd)/var/beacond
export BEACOND_CONFIG=$BEACOND_DATA/config  # don't change this. sorry.

export EL_AUTHRPC_PORT=8551
export RPC_DIAL_URL=http://localhost:$EL_AUTHRPC_PORT
export JWT_PATH=$BEACOND_CONFIG/jwt.hex
export LOG_DIR=$(pwd)/logs

if command -v reth >/dev/null 2>&1; then
    export RETH_BIN=`/usr/bin/which reth`
    export RETH_DATA=$(pwd)/var/reth
    export RETH_GENESIS_PATH=$RETH_DATA/genesis.json
fi  

if command -v geth >/dev/null 2>&1; then
    export GETH_BIN=`/usr/bin/which geth`
    export GETH_DATA=$(pwd)/var/geth
    export GETH_GENESIS_PATH=$GETH_DATA/genesis.json
fi  

if command -v Nethermind.Runner >/dev/null 2>&1; then
    export NETHERMIND_BIN=`/usr/bin/which Nethermind.Runner`
    export NETHERMIND_CONFIG_DIR=$(pwd)/var/nethermind/config/
    export NETHERMIND_DATA_DIR=$(pwd)/var/nethermind/data/
    export NETHERMIND_GENESIS_PATH="${NETHERMIND_CONFIG_DIR}/eth-nether-genesis.json"
fi  

if [ -z "$RETH_BIN" ] && [ -z "$GETH_BIN" ] && [ -z "$NETHERMIND_BIN" ]; then
    echo "Error: No execution client found in PATH"
    echo "Please install either reth, geth, or Nethermind and ensure it is available in your PATH"
    exit 1
fi
