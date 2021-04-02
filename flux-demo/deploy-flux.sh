export GITHUB_TOKEN=$PAT_GITHUB_TOKEN

# this will deploy flux and commit all the infra-as-code back to your manifest repo
flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=$REPO_MANIFEST_NAME \
    --branch=main \
    --path=./cluster-manifests/flux \
    --personal \
    --token-auth \
    --private

kubectl create namespace hello-world

# Clone the private manifest repo to your local machine and commit the Flux Kustomization file for the hello-world app
git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_MANIFEST_NAME} --bare

flux create kustomization hello-world \
    --source=flux-system \
    --path="./app-manifests" \
    --prune=true \
    --validation=client \
    --interval=3m \
    --export > ./${REPO_MANIFEST_NAME}/cluster-manifests/flux/hello-world-kustomization.yaml

cd ./${REPO_MANIFEST_NAME}
git add .
git commit -m "kustomization file for hello-world"
git push
cd ..