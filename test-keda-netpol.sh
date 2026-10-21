#!/bin/bash
set -euo pipefail

# Test script for KEDA network policies
# ========================================
# This script tests network policies required for KEDA's external metrics API server.
# 
# Context: KEDA registers an APIService (v1beta1.external.metrics.k8s.io) with the
# Kubernetes API server. The API server needs to reach KEDA's metrics API server
# pod on port 443. This requires:
#   - Ingress on port 443 to the metrics API server pod
#   - Egress from the metrics API server pod to the Kubernetes API server
#
# Usage:
#   ./test-keda-netpol.sh          # Run with defaults (auto-discovers cluster info)
#   ./test-keda-netpol.sh cleanup  # Just cleanup, no test
#
# This script:
#   1. Creates keda-test-system namespace
#   2. Applies network policies allowing metrics API server traffic
#   3. Creates a curl test pod to simulate API server connectivity
#   4. Tests connectivity to the Kubernetes API server
#   5. Auto-cleans up on exit or when Enter is pressed
#
# Per KEDA docs: https://docs.kedify.io/installation/networking/
# Kubernetes API server -> KEDA metrics API server: 443 (service) -> 6443 (pod)

NAMESPACE="keda-test-system"

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

# Handle cleanup-only mode
if [ "${1:-}" = "cleanup" ]; then
    cleanup
    exit 0
fi

echo "============================================"
echo "KEDA Network Policy Test"
echo "============================================"

# Get the Kubernetes API server IP from kubeconfig
echo "Getting Kubernetes API server info..."
API_SERVER_URL=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="'$(kubectl config current-context)'")].cluster.server}')
echo "API Server URL: ${API_SERVER_URL}"

# Extract host and port from API server URL
API_SERVER_HOST=$(echo ${API_SERVER_URL} | sed -e 's|^https://||' -e 's|:.*||')
API_SERVER_PORT=$(echo ${API_SERVER_URL} | sed -e 's|^https://||' -e 's|^[^:]*:||' -e 's|/.*||')

echo "API Server Host: ${API_SERVER_HOST}"
echo "API Server Port: ${API_SERVER_PORT}"

# Get cluster IP from kubernetes service
KUBERNETES_SVC_IP=$(kubectl get service kubernetes -n default -o jsonpath='{.spec.clusterIP}')
echo "Kubernetes Service ClusterIP: ${KUBERNETES_SVC_IP}"

echo ""

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
            cidr: ${KUBERNETES_SVC_IP}/32
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

echo "Creating namespace ${NAMESPACE} and applying network policies..."
kubectl apply -f /tmp/keda-test-values.yaml
echo ""

echo "Network policies applied:"
kubectl get netpol -n ${NAMESPACE}
echo ""

echo "Test pod created:"
kubectl get pod -n ${NAMESPACE}
echo ""

# Wait for pod to be ready
echo "Waiting for test pod to be ready (120s timeout)..."
kubectl wait --for=condition=Ready pod/curl-test -n ${NAMESPACE} --timeout=120s
echo ""

echo "Test pod is ready. Running connectivity test..."
echo "Executing: curl -k https://${KUBERNETES_SVC_IP}:${API_SERVER_PORT}/apis/external.metrics.k8s.io/v1beta1"
echo ""
kubectl exec -n ${NAMESPACE} curl-test -- curl -s -k -w "\nHTTP Status: %{http_code}\n" "https://${KUBERNETES_SVC_IP}:${API_SERVER_PORT}/apis/external.metrics.k8s.io/v1beta1" || echo "Connection failed"

echo ""
echo "============================================"
echo "Test complete. Press Enter to cleanup..."
read -r
cleanup
