#!/bin/bash

# Base values
BASE_SCRIPT="run_experiment.sh"
TRACE_FILE="./data/processed_traces/splitwise_conv.csv"

# Range of values
REPLICAS_VALUES=(4 6 8 10 12 14 16)
BATCH_SIZE_VALUES=(2 4 8 16 32 64 128 256 512 1024)
QPS_VALUES=(0.001 0.01 0.1 1 2 5 10 20 50 100 200)

# Fixed default values
DEFAULT_REPLICAS=4
DEFAULT_BATCH_SIZE=128
DEFAULT_QPS=200

run_experiment() {
  local replicas=$1
  local batch_size=$2
  local qps=$3
  for i in {1..3}; do
    echo "Running experiment with replicas=$replicas, batch_size=$batch_size, qps=$qps"
    bash "$BASE_SCRIPT" --num_replicas "$replicas" --batch_size "$batch_size" --qps "$qps"
  done
}

# Test each NUM_REPLICAS with fixed batch size and QPS
echo "Testing different NUM_REPLICAS with fixed batch_size=$DEFAULT_BATCH_SIZE and qps=$DEFAULT_QPS"
for NUM_REPLICAS in "${REPLICAS_VALUES[@]}"; do
  run_experiment "$NUM_REPLICAS" "$DEFAULT_BATCH_SIZE" "$DEFAULT_QPS"
done

# Test each BATCH_SIZE with fixed replicas and QPS
echo "Testing different BATCH_SIZE with fixed replicas=$DEFAULT_REPLICAS and qps=$DEFAULT_QPS"
for BATCH_SIZE in "${BATCH_SIZE_VALUES[@]}"; do
  run_experiment "$DEFAULT_REPLICAS" "$BATCH_SIZE" "$DEFAULT_QPS"
done

# Test each QPS with fixed replicas and batch size
echo "Testing different QPS with fixed replicas=$DEFAULT_REPLICAS and batch_size=$DEFAULT_BATCH_SIZE"
for QPS in "${QPS_VALUES[@]}"; do
  run_experiment "$DEFAULT_REPLICAS" "$DEFAULT_BATCH_SIZE" "$QPS"
done

