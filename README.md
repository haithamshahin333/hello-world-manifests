# Manifest Repo for Hello-World Api

This repo functions as a manifest repo. In a GitOps CI/CD model, this repo acts as the single source of truth for everything that should be deployed in the cluster.

## Folders

1. `app-manifests` - this contains all the resources needed to deploy the [hello-world app](https://github.com/haithamshahin333/express-node-hello-world-app). As part of the Workflow for the hello-world app, a commit is made back to this folder using `kustomize edit set image` so that the folder points to the latest image.