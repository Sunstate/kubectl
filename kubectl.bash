#!/bin/bash

# If there is no current context, get one.
if [[ $(kubectl config current-context 2> /dev/null) == "" ]]; then
    cluster=$(gcloud config get-value container/cluster 2> /dev/null)
    region=$(gcloud config get-value compute/region 2> /dev/null)
    project=$(gcloud config get-value core/project 2> /dev/null)

    function var_usage() {
        cat <<EOF
No cluster is set. To set the cluster (and the region where it is found), set the environment variables
  CLOUDSDK_COMPUTE_REGION=<cluster region>
  CLOUDSDK_CONTAINER_CLUSTER=<cluster name>
EOF
        exit 1
    }

    [[ -z "$cluster" ]] && var_usage
    [[ -z "$region" ]] && var_usage

    echo "Running: gcloud beta container clusters get-credentials --project=\"$project\" --region=\"$region\" \"$cluster\""
    gcloud beta container clusters get-credentials --project="$project" --region="$region" "$cluster" || exit
fi

echo "Running: kubectl $@"
kubectl "$@"