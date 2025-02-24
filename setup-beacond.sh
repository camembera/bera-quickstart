#!/bin/bash

set -e
. ./env.sh
mkdir -p $BEACOND_DATA
mkdir -p $BEACOND_CONFIG
mkdir -p "$LOG_DIR"

# Check executables exist and are executable
if [ ! -x "$BEACOND_BIN" ]; then
    echo "Error: beacond executable $BEACOND_BIN does not exist or is not executable"
    exit 1
fi

if [ -f "$BEACOND_CONFIG/priv_validator_key.json" ]; then
    echo "Error: $BEACOND_CONFIG/priv_validator_key.json already exists"
    exit 1
fi

echo "BEACOND_DATA: $BEACOND_DATA"
echo "BEACOND_BIN: $BEACOND_BIN"
echo "  Version: $($BEACOND_BIN version)"

$BEACOND_BIN init $MONIKER_NAME --chain-id $CHAIN --home $BEACOND_DATA 2>/dev/null

cp seed-data/genesis.json $BEACOND_CONFIG/genesis.json
cp seed-data/kzg-trusted-setup.json $BEACOND_CONFIG/kzg-trusted-setup.json
cp seed-data/app.toml $BEACOND_CONFIG/app.toml
cp seed-data/config.toml $BEACOND_CONFIG/config.toml

# choose sed options based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_OPT="-i ''"
else
    SED_OPT='-i'
fi

sed $SED_OPT 's|^moniker = ".*"|moniker = "'$MONIKER_NAME'"|' $BEACOND_CONFIG/config.toml
sed $SED_OPT 's|^rpc-dial-url = ".*"|rpc-dial-url = "'$RPC_DIAL_URL'"|' $BEACOND_CONFIG/app.toml
sed $SED_OPT 's|^jwt-secret-path = ".*"|jwt-secret-path = "'$JWT_PATH'"|' $BEACOND_CONFIG/app.toml
sed $SED_OPT 's|^trusted-setup-path = ".*"|trusted-setup-path = "'$BEACOND_CONFIG/kzg-trusted-setup.json'"|' $BEACOND_CONFIG/app.toml
sed $SED_OPT 's|^suggested-fee-recipient = ".*"|suggested-fee-recipient = "'$WALLET_ADDRESS_FEE_RECIPIENT'"|' $BEACOND_CONFIG/app.toml

$BEACOND_BIN jwt generate -o $JWT_PATH

echo
echo 
echo "✓ Beacon-Kit set up."
