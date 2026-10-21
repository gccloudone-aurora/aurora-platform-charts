#!/bin/bash
set -euo pipefail

# Simple KEDA network policy test
# Creates minimal test resources and tests connectivity

NAMESPACE="keda-test-$(date +%s)"

cleanup() {
    echo ""
    echo "Cleaning up..."
    kubectl delete namespace ${NAMESPACE} 2>/dev/null || true
    echo "Done."
}

trap cleanup EXIT

echo "========================================"
echo "Simple KEDA Network Policy Test"
echo "========================================"
echo ""

# Create namespace
echo "1. Creating namespace ${NAMESPACE}..."
kubectl create namespace ${NAMESPACE}

# Create a simple netpol (allow all within namespace)
echo "2. Creating network policy..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-in-namespace
  namespace: ${NAMESPACE}
spec:
  podSelector: {}
  ingress:
  - from:
    - podSelector: {}
  egress:
  - to:
    - podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF

# Create test server pod (using busybox httpd for simplicity)
echo "3. Creating test server pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test-server
  namespace: ${NAMESPACE}
spec:
  containers:
  - name: server
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - |
      echo 'Starting simple HTTP server...'
      echo 'Hello from test server' > /tmp/index.html
      httpd -f -h /tmp -p 8080
    ports:
    - containerPort: 8080
EOF

# Create client pod
echo "4. Creating client pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test-client
  namespace: ${NAMESPACE}
spec:
  containers:
  - name: client
    image: curlimages/curl
    command: ["sleep", "3600"]
EOF

# Wait for pods
echo "5. Waiting for pods to be ready..."
sleep 10
kubectl wait --for=condition=Ready pod/test-server -n ${NAMESPACE} --timeout=30s
kubectl wait --for=condition=Ready pod/test-client -n ${NAMESPACE} --timeout=30s

# Test connectivity
echo "6. Testing connectivity..."
SERVER_IP=$(kubectl get pod test-server -n ${NAMESPACE} -o jsonpath='{.status.podIP}')
echo "Server IP: ${SERVER_IP}"

echo "Testing curl from client to server:8080..."
if kubectl exec -n ${NAMESPACE} test-client -- curl -s -o /dev/null -w "%{http_code}" "http://${SERVER_IP}:8080" --connect-timeout 5; then
    echo ""
    echo "✓ SUCCESS: Connectivity test passed!"
    echo ""
    echo "This confirms that network policies allowing intra-namespace"
    echo "communication work correctly. For KEDA, you need:"
    echo ""
    echo "1. Similar 'allow-same-namespace' policy in keda-system"
    echo "2. DNS egress policy for service discovery"
    echo "3. Ingress on port 443 to keda-metrics-apiserver pods"
    echo "4. Egress policies for external metrics sources"
else
    echo ""
    echo "✗ FAILED: Connectivity test failed"
    echo ""
    echo "Debug info:"
    kubectl get pods -n ${NAMESPACE} -o wide
    kubectl get netpol -n ${NAMESPACE}
fi

echo ""
echo "========================================"
echo "Test complete. Resources will auto-cleanup."
echo "========================================"