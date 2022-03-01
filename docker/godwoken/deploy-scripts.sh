#!/bin/bash

WORKSPACE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [ -e "$WORKSPACE/scripts-deployment.json" ]; then
    echo "$WORKSPACE/scripts-deployment.json already exists, skip"
    exit 0;
fi

RUST_BACKTRACE=full gw-tools deploy-scripts \
    --ckb-rpc http://ckb:8114 \
    -i $WORKSPACE/scripts-config.json \
    -o $WORKSPACE/scripts-deployment.json \
    -k $WORKSPACE/../share/test_only_privkey_of_block_assembler
