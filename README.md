# GitOps Workflows with Argo CD and Flux V2

This repo has two GitOps demos on AKS using either Argo CD or Flux V2. Select the directory below to follow a demo for one of the two options.

This repo also functions as a manifest repo for our demos. In a GitOps CI/CD model, this repo acts as the single source of truth for everything that should be deployed in the cluster.

## Folders

1. `app-manifests` - this contains all the resources needed to deploy the [hello-world app](https://github.com/haithamshahin333/express-node-hello-world-app). As part of the Workflow for the hello-world app, a commit is made back to this folder using `kustomize edit set image` so that the folder points to the latest image.

2. [`flux-demo`](./flux-demo/README.md) - contains the instructions to deploy a GitOps workflow with Flux V2.

3. [`argo-demo`](./argo-demo/README.md) - contains the instructions to deploy a GitOps workflow with Argo CD.