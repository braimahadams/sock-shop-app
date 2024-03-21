#!/bin/bash

# Get the directory path of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Array of YAML files in reverse order
yaml_files=(
    "26-prometheus-node-exporter-svc.yaml"
    "25-prometheus-node-exporter-daemonset.yaml"
    "24-prometheus-node-exporter-sa.yaml"
    "23-grafana-import-dash-batch.yaml"
    "22-grafana-svc.yaml"
    "21-grafana-dep.yaml"
    "20-grafana-configmap.yaml"
    "14-kube-state-svc.yaml"
    "13-kube-state-dep.yaml"
    "12-kube-state-crb.yaml"
    "11-kube-state-cr.yaml"
    "10-kube-state-sa.yaml"
    "08-prometheus-exporter-disk-usage-ds.yaml"
    "07-prometheus-svc.yaml"
    "06-prometheus-dep.yaml"
    "05-prometheus-alertrules.yaml"
    "04-prometheus-configmap.yaml"
    "03-prometheus-crb.yaml"
    "02-prometheus-cr.yaml"
    "01-prometheus-sa.yaml"
    "00-monitoring-ns.yaml"
)

# Delete the resources in reverse order
for yaml_file in "${yaml_files[@]}"; do
    kubectl delete -f "$SCRIPT_DIR/$yaml_file"
done
