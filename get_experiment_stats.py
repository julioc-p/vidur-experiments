import pandas as pd
import argparse
import os
import json

def get_experiments_stats(experiment_dir):
  results = {}
  for folder in os.listdir(experiment_dir):
    if not folder.startswith("replicas"):
      continue
    avg_request_scheduling_delay, mfu = get_folder_stats(experiment_dir, folder)
    results[folder] = {"avg_request_scheduling_delay": avg_request_scheduling_delay, "avg_mfu": mfu}
  return results

def get_folder_stats(experiment_dir, folder):
  num_requests = 0
  total_request_scheduling_delay = 0
  total_mfu = 0
  replicas = 0
  experiments_dir = os.path.join(experiment_dir, folder)
  for folder in os.listdir(experiments_dir):
    num_requests_single_experiment, total_request_scheduling_delay_single_experiment, total_mfu_single_experiment, replicas_single_experiment = get_single_experiment_stats(os.path.join(experiments_dir, folder))
    num_requests += num_requests_single_experiment
    total_request_scheduling_delay += total_request_scheduling_delay_single_experiment
    total_mfu += total_mfu_single_experiment
    replicas += replicas_single_experiment
  
  try:
    avg_request_scheduling_delay = total_request_scheduling_delay / num_requests
  except ZeroDivisionError:
    avg_request_scheduling_delay = 0

  try:
    mfu = total_mfu / replicas
  except ZeroDivisionError:
    mfu = 0

  return avg_request_scheduling_delay, mfu

def get_single_experiment_stats(experiment_dir):
  try:
    request_metrics = pd.read_csv(os.path.join(experiment_dir, "request_metrics.csv"))
    num_requests = request_metrics.shape[0]
    total_request_scheduling_delay = request_metrics["request_scheduling_delay"].sum()
    num_replicas = get_number_replicas(experiment_dir)
    total_mfu = get_mfu(experiment_dir)
    return num_requests, total_request_scheduling_delay, total_mfu, num_replicas
  except FileNotFoundError as e:
    return 0, 0, 0, 0

def get_number_replicas(experiment_dir):
  replicas = 0
  # for each file in the plots folder
  for file in os.listdir(os.path.join(experiment_dir, "plots")):
    if "mfu" in file:
      replicas += 1
  return replicas
  
def get_mfu(experiment_dir):
  mfu = 0
  for file in os.listdir(os.path.join(experiment_dir, "plots")):
    if "mfu" in file:
      mfu += get_mfu_single_replica(os.path.join(experiment_dir, "plots", file))
  return mfu

def get_mfu_single_replica(file):
  mfu = 0
  with open(file) as f:
    data = json.load(f)
    for key in data:
      if key.endswith("weighted_mean"):
        mfu += data[key]
  return mfu

def get_single_stats(element, experiment_stats):
  results = {}
  indices_split = {"replica":1, "batch":3,"qps":5 }
  for experiment in experiment_stats:
      type_element = experiment.split("_")[indices_split[element]]
      if type_element not in results:
          results[type_element] = {"avg_mfu": [], "avg_request_scheduling_delay": []}
      results[type_element]["avg_mfu"].append(experiment_stats[experiment]["avg_mfu"])
      results[type_element]["avg_request_scheduling_delay"].append(experiment_stats[experiment]["avg_request_scheduling_delay"])
  for type_element in results:
      results[type_element]["avg_mfu"] = sum(results[type_element]["avg_mfu"]) / len(results[type_element]["avg_mfu"])
      results[type_element]["avg_request_scheduling_delay"] = sum(results[type_element]["avg_request_scheduling_delay"]) / len(results[type_element]["avg_request_scheduling_delay"])
  return results

if __name__ == '__main__':

    experiment_dir = "simulator_output"
    experiment_stats = get_experiments_stats(experiment_dir)
    for element in ["replica", "batch", "qps"]:
        print(element.capitalize())
        print(get_single_stats(element, experiment_stats))
    
    #print(experiment_stats)

