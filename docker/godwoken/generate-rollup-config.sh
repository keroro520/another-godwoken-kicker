#!/bin/bash
#
# Generate "rollup-config.json" according to "scripts-deployment.json"

rollup_config_template='{
  "l1_sudt_script_type_hash": "L1_SUDT_SCRIPT_TYPE_HASH",
  "l1_sudt_cell_dep": {
    "dep_type": "code",
    "out_point": {
      "tx_hash": "L1_SUDT_CELL_DEP_OUT_POINT_TX_HASH",
      "index": "L1_SUDT_CELL_DEP_OUT_POINT_INDEX"
    }
  },
  "cells_lock": {
    "code_hash": "0x1111111111111111111111111111111111111111111111111111111111111111",
    "hash_type": "type",
    "args": "0x0000000000000000000000000000000000000000"
  },
  "reward_lock": {
    "code_hash": "0x1111111111111111111111111111111111111111111111111111111111111111",
    "hash_type": "type",
    "args": "0x0000000000000000000000000000000000000001"
  },
  "burn_lock": {
    "code_hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "hash_type": "data",
    "args": "0x"
  },
  "required_staking_capacity": 10000000000,
  "challenge_maturity_blocks": 100,
  "finality_blocks": 100,
  "reward_burn_rate": 50,
  "allowed_eoa_type_hashes": []
}'

function get_value2() {
    filepath=$1
    key1=$2
    key2=$3

    echo "$(cat $filepath)" | grep -Pzo ''$key1'[^}]*'$key2'":[\s]*"\K[^"]*'
}

function render_rollup_config() {
    script_deployment_file="$1"
    l1_sudt_script_type_hash=$(get_value2 "$script_deployment_file" "l2_sudt_validator" "script_type_hash")
    l1_sudt_cell_dep_out_point_tx_hash=$(get_value2 "$script_deployment_file" "l2_sudt_validator" "tx_hash")
    l1_sudt_cell_dep_out_point_index=$(get_value2 "$script_deployment_file" "l2_sudt_validator" "index")

    if [ -z "$l1_sudt_script_type_hash" ]; then
        echo "ERROR: Can not find l2_sudt_validator.script_type_hash from $script_deployment_file"
        exit 1
    fi

    echo "$rollup_config_template" \
        | sed "s/L1_SUDT_SCRIPT_TYPE_HASH/$l1_sudt_script_type_hash/g" \
        | sed "s/L1_SUDT_CELL_DEP_OUT_POINT_TX_HASH/$l1_sudt_cell_dep_out_point_tx_hash/g" \
        | sed "s/L1_SUDT_CELL_DEP_OUT_POINT_INDEX/$l1_sudt_cell_dep_out_point_index/g"
}

WORKSPACE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
script_deployment_file="$WORKSPACE/scripts-deployment.json"
rollup_config_file="$WORKSPACE/rollup-config.json"

if [ -e $rollup_config_file ]; then
    echo "$rollup_config_file already exists, skip"
    exit 0;
fi

echo $(render_rollup_config "$script_deployment_file") > $rollup_config_file
echo "Generate rollup config to \"$rollup_config_file\" successfully"
