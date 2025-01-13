#!/bin/bash

# Default values for parameters
NUM_REPLICAS=1
QPS=0.5
BATCH_SIZE=1

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --num_replicas)
      NUM_REPLICAS=$2
      shift 2
      ;;
    --qps)
      QPS=$2
      shift 2
      ;;
    --batch_size)
      BATCH_SIZE=$2
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

OUTPUT_DIR="simulator_output/replicas_${NUM_REPLICAS}_batch_${BATCH_SIZE}_qps_${QPS}"

# Run the Python command with the specified parameters
python -m vidur.main \
  --replica_config_device a100 \
  --replica_config_model_name meta-llama/Meta-Llama-3-8B \
  --cluster_config_num_replicas $NUM_REPLICAS \
  --replica_config_tensor_parallel_size 1 \
  --replica_config_num_pipeline_stages 1 \
  --request_generator_config_type synthetic \
  --synthetic_request_generator_config_num_requests 512 \
  --length_generator_config_type trace \
  --trace_request_length_generator_config_max_tokens 4096 \
  --trace_request_length_generator_config_trace_file ./data/processed_traces/splitwise_conv.csv \
  --interval_generator_config_type poisson \
  --poisson_request_interval_generator_config_qps $QPS \
  --replica_scheduler_config_type vllm \
  --vllm_scheduler_config_batch_size_cap $BATCH_SIZE \
  --random_forrest_execution_time_predictor_config_prediction_max_prefill_chunk_size 4096 \
  --random_forrest_execution_time_predictor_config_prediction_max_batch_size $BATCH_SIZE \
  --random_forrest_execution_time_predictor_config_prediction_max_tokens_per_request 4096 \
  --metrics_config_output_dir $OUTPUT_DIR
