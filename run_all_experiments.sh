#!/bin/bash

# Base values
BASE_SCRIPT="run_experiment.sh"
TRACE_FILE="./data/processed_traces/splitwise_conv.csv"

# Range of values
REPLICAS_VALUES=(1 2 4 8 16 32 64 128 256 512) # 2^i for i in [0, 9]
BATCH_SIZE_VALUES=(1 2 4 8 16 32 64 128 256 512) # 2^i for i in [0, 9]
QPS_VALUES=$(seq 1 116)

# Loop over all combinations
for NUM_REPLICAS in "${REPLICAS_VALUES[@]}"; do
  for BATCH_SIZE in "${BATCH_SIZE_VALUES[@]}"; do
    for QPS in $QPS_VALUES; do
      echo "Running experiment with replicas=$NUM_REPLICAS, batch_size=$BATCH_SIZE, qps=$QPS"
      
      # Run the original script with these parameters
      bash "$BASE_SCRIPT" --num_replicas "$NUM_REPLICAS" --batch_size "$BATCH_SIZE" --qps "$QPS"
    
    done
  done
done
