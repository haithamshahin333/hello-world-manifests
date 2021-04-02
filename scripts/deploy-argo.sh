# Deploy Argo CD to argocd namespace
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose Argo CD UI
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Create secret in argo cd namespace with deploy key pair
kubectl create secret generic github-credentials --from-literal=username=argocd --from-literal=password=$PAT_GITHUB_TOKEN -n argocd

# Update Argo CD with repo credentials
cat << EOF >> argocd-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  repositories: |
    - url: $REPO_HTTPS_MANIFEST_URL
      passwordSecret:
        name: github-credentials
        key: password
      usernameSecret:
        name: github-credentials
        key: username
EOF

kubectl apply -f argocd-cm.yaml

# Create Argo Application with Auto Sync enabled and deploy to hello-world namespace
kubectl create namespace hello-world

cat << EOF >> application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: hello-world-kustomize
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
  project: default
  syncPolicy:
    automated:
      prune: true
  source:
    path: app-manifests
    repoURL: $REPO_HTTPS_MANIFEST_URL
    targetRevision: main
EOF

kubectl apply -f application.yaml

# Argo CD login info
ARGO_PASSWORD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo "Argo CD Username: admin"
echo "Argo CD Password: $ARGO_PASSWORD"
echo "Check argo service to view public-facing load balancer to access UI"
