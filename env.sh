#!/bin/bash 

set -e

# CHANGE THESE TWO VALUES
export MONIKER_NAME=camembera
export WALLET_ADDRESS_FEE_RECIPIENT=0x9BcaA41DC32627776b1A4D714Eef627E640b3EF5

# CHAIN CONSTANTS
export CHAIN=mainnet-beacon-80094
export SEED_DATA_URL=https://raw.githubusercontent.com/berachain/beacon-kit/refs/heads/main/testing/networks/80094

# THESE DEPEND ON YOUR LOCAL SETUP
export BEACOND_BIN=`/usr/bin/which beacond || echo beacond`
export BEACOND_DATA=$(pwd)/var/beacond
export BEACOND_CONFIG=$(pwd)/var/beacond/config

export EL_AUTHRPC_PORT=8551
export RPC_DIAL_URL=http://localhost:$EL_AUTHRPC_PORT
export JWT_PATH=$BEACOND_CONFIG/jwt.hex
export LOG_DIR=$(pwd)/logs

# maybe you're running reth
export RETH_BIN=`/usr/bin/which reth1.1 || echo reth`
export RETH_DATA=$(pwd)/var/reth
export RETH_GENESIS_PATH=$RETH_DATA/genesis.json

# OR maybe you're running geth
export GETH_BIN=`/usr/bin/which geth || echo geth`
export GETH_DATA=$(pwd)/var/geth
export GETH_GENESIS_PATH=$GETH_DATA/genesis.json

# OR maybe you're running nethermind
export NETHERMIND_BIN=`/usr/bin/which Nethermind.Runner || echo nethermind`
export NETHERMIND_CONFIG_DIR=$(pwd)/var/nethermind/config/
export NETHERMIND_DATA_DIR=$(pwd)/var/nethermind/data/
export NETHERMIND_GENESIS_PATH="${NETHERMIND_CONFIG_DIR}/eth-nether-genesis.json"
