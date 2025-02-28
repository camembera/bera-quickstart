#!/bin/bash 

# CHANGE THESE VALUES
export CHAIN_SPEC="mainnet"
export MONIKER_NAME=camembera
export WALLET_ADDRESS_FEE_RECIPIENT=0x9BcaA41DC32627776b1A4D714Eef627E640b3EF5
export EL_ARCHIVE_NODE=false # set to true if you want to run an archive node on CL and EL
export MY_IPV4=`curl canhazip.com`

# THESE DEPEND ON YOUR LOCAL SETUP
export BEACOND_BIN=$(command -v beacond || echo $(pwd)/beacond)
export BEACOND_DATA=$(pwd)/var/beacond
export BEACOND_CONFIG=$BEACOND_DATA/config  # don't change this. sorry.

export EL_AUTHRPC_PORT=31000
export EL_ETHRPC_PORT=31001
export EL_ETHP2P_PORT=31002
export EL_ETHPROXY_PORT=31003

export CL_ETHRPC_PORT=31004
export CL_ETH_PORT=31005
export PROMETHEUS_PORT=31006
export RPC_DIAL_URL=http://localhost:$EL_AUTHRPC_PORT
export JWT_PATH=$BEACOND_CONFIG/jwt.hex
export LOG_DIR=$(pwd)/logs

# CHAIN CONSTANTS
if [[ "$CHAIN_SPEC" == "testnet" ]]; then
    export CHAIN=testnet-beacon-80069
    export CHAIN_ID=80069
else
    export CHAIN=mainnet-beacon-80094
    export CHAIN_ID=80094
fi
export SEED_DATA_URL=https://raw.githubusercontent.com/berachain/beacon-kit/refs/heads/main/testing/networks/$CHAIN_ID

# identify the execution client and choose paths; you can override the data directories
if command -v reth >/dev/null 2>&1; then
    export RETH_BIN=$(command -v reth)
    export RETH_DATA=$(pwd)/var/reth
    export RETH_GENESIS_PATH=$RETH_DATA/genesis.json
fi  

if command -v geth >/dev/null 2>&1; then
    export GETH_BIN=$(command -v geth)
    export GETH_DATA=$(pwd)/var/geth
    export GETH_GENESIS_PATH=$GETH_DATA/genesis.json
fi  

if command -v Nethermind.Runner >/dev/null 2>&1; then
    export NETHERMIND_BIN=$(command -v Nethermind.Runner)
    export NETHERMIND_CONFIG_DIR=$(pwd)/var/nethermind/config/
    export NETHERMIND_DATA_DIR=$(pwd)/var/nethermind/data/
    export NETHERMIND_GENESIS_PATH="${NETHERMIND_CONFIG_DIR}/eth-nether-genesis.json"
fi  

if [ ! "$RETH_BIN" ] && [ ! "$GETH_BIN" ] && [ ! "$NETHERMIND_BIN" ]; then
    echo "Error: No execution client found in PATH"
    echo "Please install either reth, geth, or Nethermind and ensure it is available in your PATH"
    exit 1
fi

# sed options for config file rewriting
if [[ "$OSTYPE" == "darwin"* ]]; then
    export SED_OPT="-i ''"
else
    export SED_OPT='-i'
fi
