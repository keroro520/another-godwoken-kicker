#!/bin/bash

WORKSPACE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ -e "$WORKSPACE/godwoken-config.toml" ]; then
    echo "$WORKSPACE/godwoken-config.toml already exists, skip"
    exit 0;
fi

RUST_BACKTRACE=full gw-tools generate-config \
    --ckb-rpc http://ckb:8114 \
    --ckb-indexer-rpc http://ckb-indexer:8116 \
    -d postgres://user@password@postgres:5432/lumos \
    -c $WORKSPACE/scripts-config.json \
    --scripts-deployment-path $WORKSPACE/scripts-deployment.json \
    -g $WORKSPACE/rollup-genesis-deployment.json \
    --rollup-config $WORKSPACE/rollup-config.json \
    --privkey-path $WORKSPACE/.test_only_privkey_of_block_assembler \
    -o $WORKSPACE/godwoken-config.toml \
    --rpc-server-url 0.0.0.0:8119

sed -i 's/readonly/fullnode/'  $WORKSPACE/godwoken-config.toml
