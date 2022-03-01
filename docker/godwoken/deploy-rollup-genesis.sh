#!/bin/bash

WORKSPACE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ -e "$WORKSPACE/rollup-genesis-deployment.json" ]; then
    echo "$WORKSPACE/rollup-genesis-deployment.json already exists, skip"
    exit 0;
fi

RUST_BACKTRACE=full gw-tools deploy-genesis \
    --ckb-rpc http://ckb:8114 \
    --scripts-deployment-path $WORKSPACE/scripts-deployment.json \
    --rollup-config $WORKSPACE/rollup-config.json \
    -p $WORKSPACE/poa-config.json \
    -o $WORKSPACE/rollup-genesis-deployment.json \
    -k $WORKSPACE/.test_only_privkey_of_block_assembler
