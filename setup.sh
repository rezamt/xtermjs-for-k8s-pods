echo "Configuring xtermjs cluster"

# Define namespace/project name
KUBERNETES_NAMESPACE=xtermjs

# Get the K8s API Server
echo "Getting K8s API Server details"
KUBERNETES_HOST=$(kubectl cluster-info | grep "Kubernetes control plane" | awk -F"https://|:" '{print $2 ":" $3}')

# Create namespace
echo "Create namespace"
kubectl create ns $KUBERNETES_NAMESPACE

# Creates service account and assigns needs permissions and finally the secret
echo "Creates service account and assigns needs permissions and finally the secret"
kubectl apply -n $KUBERNETES_NAMESPACE -f k8s/service-account.yml

# Create test Alpine deployment
echo "Running an Alpine pod"
kubectl apply -n $KUBERNETES_NAMESPACE -f k8s/alpine-deployment.yml


echo "Obtaining service account token"
TOKEN_NAME=$(kubectl get secrets -n $KUBERNETES_NAMESPACE | grep terminal-account-token | head -n 1 | cut -d " " -f1)
KUBERNETES_SERVICE_ACCOUNT_TOKEN=$(kubectl describe secret $TOKEN_NAME -n $KUBERNETES_NAMESPACE | grep -o -E "ey.+")

# Get list of pods
echo "Getting List of Pods"
kubectl get pods -n $KUBERNETES_NAMESPACE

# Append required config
echo "Creating .env file"
cat <<EOF >> .env
KUBERNETES_HOST=$KUBERNETES_HOST
KUBERNETES_NAMESPACE=$KUBERNETES_NAMESPACE
KUBERNETES_SERVICE_ACCOUNT_TOKEN=$KUBERNETES_SERVICE_ACCOUNT_TOKEN
EOF

echo "Check the .env file "
cat .env