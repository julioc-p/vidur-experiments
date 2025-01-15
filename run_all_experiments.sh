#!/bin/bash

# Base values
BASE_SCRIPT="run_experiment.sh"
TRACE_FILE="./data/processed_traces/splitwise_conv.csv"

# Range of values
REPLICAS_VALUES=(1 2 4 8 16 32 64 128 256 512) # 2^i for i in [0, 9]
BATCH_SIZE_VALUES=(1 2 4 8 16 32 64 128 256 512) # 2^i for i in [0, 9]
QPS_VALUES=$(seq 1 116)

# Fixed default values
DEFAULT_REPLICAS=1
DEFAULT_BATCH_SIZE=1
DEFAULT_QPS=0.5

# Test each NUM_REPLICAS with fixed batch size and QPS
echo "Testing different NUM_REPLICAS with fixed batch_size=$DEFAULT_BATCH_SIZE and qps=$DEFAULT_QPS"
for NUM_REPLICAS in "${REPLICAS_VALUES[@]}"; do
  echo "Running experiment with replicas=$NUM_REPLICAS, batch_size=$DEFAULT_BATCH_SIZE, qps=$DEFAULT_QPS"
  bash "$BASE_SCRIPT" --num_replicas "$NUM_REPLICAS" --batch_size "$DEFAULT_BATCH_SIZE" --qps "$DEFAULT_QPS"
done

# Test each BATCH_SIZE with fixed replicas and QPS
echo "Testing different BATCH_SIZE with fixed replicas=$DEFAULT_REPLICAS and qps=$DEFAULT_QPS"
for BATCH_SIZE in "${BATCH_SIZE_VALUES[@]}"; do
  echo "Running experiment with replicas=$DEFAULT_REPLICAS, batch_size=$BATCH_SIZE, qps=$DEFAULT_QPS"
  bash "$BASE_SCRIPT" --num_replicas "$DEFAULT_REPLICAS" --batch_size "$BATCH_SIZE" --qps "$DEFAULT_QPS"
done

# Test each QPS with fixed replicas and batch size
echo "Testing different QPS with fixed replicas=$DEFAULT_REPLICAS and batch_size=$DEFAULT_BATCH_SIZE"
for QPS in $QPS_VALUES; do
  echo "Running experiment with replicas=$DEFAULT_REPLICAS, batch_size=$DEFAULT_BATCH_SIZE, qps=$QPS"
  bash "$BASE_SCRIPT" --num_replicas "$DEFAULT_REPLICAS" --batch_size "$DEFAULT_BATCH_SIZE" --qps "$QPS"
done

