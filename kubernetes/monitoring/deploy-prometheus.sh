#!/bin/bash

# Get the directory path of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Array of YAML files in the correct order
yaml_files=(
    "00-monitoring-ns.yaml"
    "01-prometheus-sa.yaml"
    "02-prometheus-cr.yaml"
    "03-prometheus-crb.yaml"
    "04-prometheus-configmap.yaml"
    "05-prometheus-alertrules.yaml"
    "06-prometheus-dep.yaml"
    "07-prometheus-svc.yaml"
    "08-prometheus-exporter-disk-usage-ds.yaml"
    "10-kube-state-sa.yaml"
    "11-kube-state-cr.yaml"
    "12-kube-state-crb.yaml"
    "13-kube-state-dep.yaml"
    "14-kube-state-svc.yaml"
    "20-grafana-configmap.yaml"
    "21-grafana-dep.yaml"
    "22-grafana-svc.yaml"
    "23-grafana-import-dash-batch.yaml"
    "24-prometheus-node-exporter-sa.yaml"
    "25-prometheus-node-exporter-daemonset.yaml"
    "26-prometheus-node-exporter-svc.yaml"
)

# Loop through YAML files and apply them
for yaml_file in "${yaml_files[@]}"; do
    kubectl apply -f "$SCRIPT_DIR/$yaml_file"
done


echo "Sleeping for 2 minutes to allow Grafana to start..."
sleep 2m

# Port forward Grafana service in the background
kubectl port-forward svc/grafana 3000:80 -n monitoring &
kubectl port-forward svc/prometheus 9090:9090 -n monitoring &

# Wait for a few seconds to ensure port forwarding has started
sleep 5

# Apply Grafana import dashboards and Prometheus configurations
kubectl apply -f "$SCRIPT_DIR/23-grafana-import-dash-batch.yaml"
kubectl apply -f "$SCRIPT_DIR/24-prometheus-node-exporter-sa.yaml"
kubectl apply -f "$SCRIPT_DIR/25-prometheus-node-exporter-daemonset.yaml"
kubectl apply -f "$SCRIPT_DIR/26-prometheus-node-exporter-svc.yaml"
