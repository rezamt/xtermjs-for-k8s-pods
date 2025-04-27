# Make sure Docker is Running.
#
# Check Docker
if ! which docker >/dev/null 2>&1; then
  echo "❌ Docker is missing! Please install it from https://www.docker.com/products/docker-desktop/ or on Mac OS: brew install colima "
  exit 1
fi

# Check Kind
if ! which kind >/dev/null 2>&1; then
  echo "❌ Kind is missing! Please install it from https://kind.sigs.k8s.io/"
  exit 1
fi

# Create Kind Cluster - https://kind.sigs.k8s.io/
echo "Creating Kind Cluster : xterm-poc"
kind create cluster --name xterm-poc --config kind-config.yaml