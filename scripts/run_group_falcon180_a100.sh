
#!/bin/bash

set -ex

if [ $# -eq 0 ]
then
	echo "Please provide group name as input"
	exit
fi

if [ -z "$1" ]
then
	echo "Input must be string"
	exit
fi

GROUP_NAME=$1
echo "Group name is : " $GROUP_NAME

SIMULATOR="python -m simulator.main"

mkdir -p logs

COMMON_ARGS=\
"--metrics_store_wandb_group $GROUP_NAME \
--replica_num_layers 80 \
--replica_num_q_heads 232 \
--replica_num_kv_heads 8 \
--replica_embedding_dim 14848 \
--replica_mlp_hidden_dim 59392 \
--no-replica_use_gated_mlp \
--replica_vocab_size 65024 \
--replica_fp16_tflops 312 \
--sklearn_execution_time_predictor_send_recv_input_file ./data/profiling/a100/p2p_intra_node.csv \
--replica_total_memory_gb 80"

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "orca" \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 8 \
# --replica_num_pipeline_stages 1 \
# --metrics_store_wandb_run_name "orca tp:8 pp:1" | tee logs/orca_tp8_pp1.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "vllm" \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 8 \
# --replica_num_pipeline_stages 1 \
# --metrics_store_wandb_run_name "vllm tp:8 pp:1" | tee logs/vllm_tp8_pp1.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "sarathi" \
# --sarathi_scheduler_chunk_size 256 \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 8 \
# --replica_num_pipeline_stages 1 \
# --metrics_store_wandb_run_name "sarathi tp:8 pp:1 cs:256" | tee logs/sarathi_tp8_pp1_cs256.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "sarathi" \
# --sarathi_scheduler_chunk_size 256 \
# --cluster_num_replicas 1 \
# --replica_num_tensor_parallel_workers 8 \
# --replica_num_pipeline_stages 8 \
# --metrics_store_wandb_run_name "sarathi tp:8 pp:8 cs:256" | tee logs/sarathi_tp8_pp8_cs256.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "dsarathi" \
# --dsarathi_scheduler_chunk_size 256 \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 8 \
# --replica_num_pipeline_stages 1 \
# --metrics_store_wandb_run_name "dsarathi tp:8 pp:1 cs:256" | tee logs/dsarathi_tp8_pp1_cs256.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "dsarathi" \
# --dsarathi_scheduler_chunk_size 256 \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 4 \
# --replica_num_pipeline_stages 2 \
# --metrics_store_wandb_run_name "dsarathi tp:4 pp:2 cs:256" | tee logs/dsarathi_tp4_pp2_cs256.log 2>&1 #&

# $SIMULATOR \
# $COMMON_ARGS \
# --replica_scheduler_provider "dsarathi" \
# --dsarathi_scheduler_chunk_size 256 \
# --cluster_num_replicas 8 \
# --replica_num_tensor_parallel_workers 2 \
# --replica_num_pipeline_stages 4 \
# --metrics_store_wandb_run_name "dsarathi tp:2 pp:4 cs:256" | tee logs/dsarathi_tp4_pp2_cs256.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 256 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 1 \
--replica_num_pipeline_stages 8 \
--metrics_store_wandb_run_name "dsarathi tp:1 pp:8 cs:256" | tee logs/dsarathi_tp4_pp2_cs256.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 512 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 8 \
--replica_num_pipeline_stages 1 \
--metrics_store_wandb_run_name "dsarathi tp:8 pp:1 cs:512" | tee logs/dsarathi_tp8_pp1_cs512.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 512 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 4 \
--replica_num_pipeline_stages 2 \
--metrics_store_wandb_run_name "dsarathi tp:4 pp:2 cs:512" | tee logs/dsarathi_tp4_pp2_cs512.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 512 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 2 \
--replica_num_pipeline_stages 4 \
--metrics_store_wandb_run_name "dsarathi tp:2 pp:4 cs:512" | tee logs/dsarathi_tp4_pp2_cs512.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 512 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 1 \
--replica_num_pipeline_stages 8 \
--metrics_store_wandb_run_name "dsarathi tp:1 pp:8 cs:512" | tee logs/dsarathi_tp4_pp2_cs512.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 1024 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 8 \
--replica_num_pipeline_stages 1 \
--metrics_store_wandb_run_name "dsarathi tp:8 pp:1 cs:1024" | tee logs/dsarathi_tp8_pp1_cs1024.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 1024 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 4 \
--replica_num_pipeline_stages 2 \
--metrics_store_wandb_run_name "dsarathi tp:4 pp:2 cs:1024" | tee logs/dsarathi_tp4_pp2_cs1024.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 1024 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 2 \
--replica_num_pipeline_stages 4 \
--metrics_store_wandb_run_name "dsarathi tp:2 pp:4 cs:1024" | tee logs/dsarathi_tp4_pp2_cs1024.log 2>&1 #&

$SIMULATOR \
$COMMON_ARGS \
--replica_scheduler_provider "dsarathi" \
--dsarathi_scheduler_chunk_size 1024 \
--cluster_num_replicas 8 \
--replica_num_tensor_parallel_workers 1 \
--replica_num_pipeline_stages 8 \
--metrics_store_wandb_run_name "dsarathi tp:1 pp:8 cs:1024" | tee logs/dsarathi_tp4_pp2_cs1024.log 2>&1 #&


# wait for all background jobs to finish
wait