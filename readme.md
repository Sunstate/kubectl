# Tool builder: `gcr.io/cloud-builders/kubectl`
This repository is a copy from [github.com/GoogleCloudPlatform/cloudbuilders/kubectl](https://github.com/GoogleCloudPlatform/cloud-builders/tree/master/kubectl) It uses Google Cloud regions instead of zone.

This Container Builder build step runs
[`kubectl`](https://kubernetes.io/docs/user-guide/kubectl-overview/).

## Using this builder with Google Container Engine

To use this builder, your
[builder service account](https://cloud.google.com/container-builder/docs/how-to/service-account-permissions)
will need IAM permissions sufficient for the operations you want to perform. For
typical read-only usage, the "Container Engine Viewer" role is sufficient. To
deploy container images on a GKE cluster, the "Container Engine Developer" role
is sufficient. Check the
[GKE IAM page](https://cloud.google.com/container-engine/docs/iam-integration)
for details.

Running the following command will give Container Builder Service Account
`container.developer` role access to your Container Engine clusters:

```sh
PROJECT="$(gcloud projects describe \
    $(gcloud config get-value core/project -q) --format='get(projectNumber)')"

gcloud projects add-iam-policy-binding $PROJECT \
    --member=serviceAccount:$PROJECT@cloudbuild.gserviceaccount.com \
    --role=roles/container.developer
```

For most use, kubectl will need to be configured to point to a specific GKE
cluster. You can configure the cluster by setting environment variables.

    CLOUDSDK_COMPUTE_REGION=<your cluster's region>
    CLOUDSDK_CONTAINER_CLUSTER=<your cluster's name>


If your GKE cluster is in a different project than Container Builder, also set:

```CLOUDSDK_CORE_PROJECT=<the GKE cluster project>```

Make sure you also grant the Container Builder service account permissions in the GKE cluster project.

Setting the environment variables above will cause this step's entrypoint to
first run a command to fetch cluster credentials as follows.

    gcloud beta container clusters get-credentials --region "$CLOUDSDK_COMPUTE_REGION" "$CLOUDSDK_CONTAINER_CLUSTER"`

Then, `kubectl` will have the configuration needed to talk to your GKE cluster.

## Building this builder

To build this builder, run the following command in this directory.

    $ gcloud container builds submit . --config=cloudbuild.yaml