#!/bin/bash
set -euo pipefail

# Test script for KEDA network policies
# This deploys ONLY the network policies to keda-test-system namespace
# without installing KEDA itself
#
# Per KEDA docs: https://docs.kedify.io/installation/networking/
# Kubernetes API server -> KEDA metrics API server: 443 -> 6443 (service -> pod)
# The API server (external to cluster) needs to reach the metrics server on port 443

CLUSTER_NAME="${1:-nddn}"
NAMESPACE="keda-test-system"
API_SERVER_CIDR="${2:-10.20.225.11/32}"

# Cleanup function to remove the test resources and namespace
cleanup() {
    echo ""
    echo "Cleaning up KEDA test resources..."
    kubectl delete -f /tmp/keda-test-values.yaml 2>/dev/null || true
    kubectl delete namespace ${NAMESPACE} 2>/dev/null || true
    rm -f /tmp/keda-test-values.yaml
    echo "Cleanup complete."
}

# Set trap to cleanup on exit or error
trap cleanup EXIT

# Create namespace and netpol values file
cat > /tmp/keda-test-values.yaml <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-metrics-apiserver
  namespace: ${NAMESPACE}
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: keda-operator-metrics-apiserver
  ingress:
    - ports:
        - protocol: TCP
          port: 443
  policyTypes:
    - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-metrics-apiserver-egress
  namespace: ${NAMESPACE}
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: keda-operator-metrics-apiserver
  egress:
    - to:
        - ipBlock:
            cidr: ${API_SERVER_CIDR}
      ports:
        - protocol: TCP
          port: 443
  policyTypes:
    - Egress
---
apiVersion: v1
kind: Pod
metadata:
  name: curl-test
  namespace: ${NAMESPACE}
  labels:
    app: curl-test
spec:
  containers:
  - name: curl
    image: curlimages/curl:latest
    command: ["sleep", "infinity"]
EOF

echo "============================================"
echo "KEDA Network Policy Test"
echo "============================================"
echo "Testing on cluster: ${CLUSTER_NAME}"
echo "Test namespace: ${NAMESPACE}"
echo "API Server CIDR: ${API_SERVER_CIDR}"
echo ""

echo "Creating namespace ${NAMESPACE} and applying network policies..."
kubectl apply -f /tmp/keda-test-values.yaml

echo ""
echo "Network policies applied:"
kubectl get netpol -n ${NAMESPACE}

echo ""
echo "Test pod created:"
kubectl get pod -n ${NAMESPACE}

# Wait for pod to be ready
echo ""
echo "Waiting for test pod to be ready..."
kubectl wait --for=condition=Ready pod/curl-test -n ${NAMESPACE} --timeout=120s

echo ""
echo "Test pod is ready. Running connectivity test..."
kubectl exec -n ${NAMESPACE} curl-test -- curl -s -k -w "\nHTTP Status: %{http_code}\n" https://10.20.225.11:443/apis/external.metrics.k8s.io/v1beta1 || echo "Connection failed (expected if API server IP is wrong or firewall blocks)"

echo ""
echo "============================================"
echo "Test complete. Press Enter to cleanup..."
read -r
cleanup
