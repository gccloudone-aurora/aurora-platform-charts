#!/bin/bash
set -euo pipefail

# Test script for KEDA network policies
# ========================================
# This script tests network policies required for KEDA's external metrics API server.
# 
# Context: KEDA registers an APIService (v1beta1.external.metrics.k8s.io) with the
# Kubernetes API server. The API server needs to reach KEDA's metrics API server
# pod on port 443. This requires:
#   - Ingress on port 443 TO the metrics API server pod (from API server)
#   - The test simulates this by checking if the pod can receive traffic on port 443
#
# Usage:
#   ./test-keda-netpol.sh          # Run with defaults (auto-discovers cluster info)
#   ./test-keda-netpol.sh cleanup  # Just cleanup, no test
#
# This script:
#   1. Creates keda-test-system namespace
#   2. Applies network policies
#   3. Creates a listener pod on port 443 to test ingress connectivity
#   4. Tests that traffic can reach port 443 from within the cluster
#   5. Auto-cleans up on exit or when Enter is pressed

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

echo ""
echo "============================================"
echo "KEDA Network Policy Test"
echo "============================================"

echo ""
echo "[STEP 1/5] Getting Kubernetes API server info from kubeconfig..."
echo "  Command: kubectl config view -o jsonpath..."
API_SERVER_URL=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="'$(kubectl config current-context)'")].cluster.server}')
echo "  Result: API Server URL: ${API_SERVER_URL}"

API_SERVER_HOST=$(echo ${API_SERVER_URL} | sed -e 's|^https://||' -e 's|:.*||')
API_SERVER_PORT=$(echo ${API_SERVER_URL} | sed -e 's|^https://||' -e 's|^[^:]*:||' -e 's|/.*||')
echo "  Result: API Server Host: ${API_SERVER_HOST}"
echo "  Result: API Server Port: ${API_SERVER_PORT}"

echo "  Command: kubectl get service kubernetes -n default -o jsonpath..."
KUBERNETES_SVC_IP=$(kubectl get service kubernetes -n default -o jsonpath='{.spec.clusterIP}')
echo "  Result: Kubernetes Service ClusterIP: ${KUBERNETES_SVC_IP}"

echo ""
echo "[STEP 2/5] Creating namespace and network policies..."
echo "  File: /tmp/keda-test-values.yaml"

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
  name: allow-same-namespace
  namespace: ${NAMESPACE}
spec:
  podSelector: {}
  ingress:
    - from:
        - podSelector: {}
  egress:
    - to:
        - podSelector: {}
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - protocol: UDP
          port: 53
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - protocol: TCP
          port: 53
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-metrics-apiserver
  namespace: ${NAMESPACE}
spec:
  podSelector:
    matchLabels:
      app: keda-metrics-listener
  ingress:
    - ports:
        - protocol: TCP
          port: 443
  policyTypes:
    - Ingress
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
---
apiVersion: v1
kind: Pod
metadata:
  name: keda-metrics-listener
  namespace: ${NAMESPACE}
  labels:
    app: keda-metrics-listener
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 443
    command: ["/bin/sh", "-c", "echo 'Listening on port 443...' && nginx -g 'daemon off;'"]
EOF

echo "  Contents:"
cat /tmp/keda-test-values.yaml | sed 's/^/    /'
echo ""
echo "  Command: kubectl apply -f /tmp/keda-test-values.yaml"
kubectl apply -f /tmp/keda-test-values.yaml

echo ""
echo "[STEP 3/5] Verifying network policies..."
echo "  Command: kubectl get netpol -n ${NAMESPACE}"
kubectl get netpol -n ${NAMESPACE}
echo ""
echo "  NetworkPolicy details:"
echo "  Command: kubectl describe netpol -n ${NAMESPACE}"
kubectl describe netpol -n ${NAMESPACE}

echo ""
echo "[STEP 4/5] Waiting for pods to be ready (120s timeout)..."
echo "  Command: kubectl get pod -n ${NAMESPACE}"
kubectl get pod -n ${NAMESPACE}
echo "  Command: kubectl wait --for=condition=Ready pod/curl-test -n ${NAMESPACE} --timeout=120s"
kubectl wait --for=condition=Ready pod/curl-test -n ${NAMESPACE} --timeout=120s
echo "  Command: kubectl wait --for=condition=Ready pod/keda-metrics-listener -n ${NAMESPACE} --timeout=120s"
kubectl wait --for=condition=Ready pod/keda-metrics-listener -n ${NAMESPACE} --timeout=120s
echo "  Result: Pods are ready!"

echo ""
echo "[STEP 5/5] Testing ingress connectivity to port 443..."

# First test DNS resolution
echo "  Testing DNS resolution..."
echo "  Command: kubectl exec -n ${NAMESPACE} curl-test -- nslookup keda-metrics-listener.${NAMESPACE}.svc.cluster.local"
kubectl exec -n ${NAMESPACE} curl-test -- nslookup keda-metrics-listener.${NAMESPACE}.svc.cluster.local 2>&1 || echo "DNS resolution failed"

# Then test direct IP connection
echo "  Getting pod IP for direct connection test..."
POD_IP=$(kubectl get pod keda-metrics-listener -n ${NAMESPACE} -o jsonpath='{.status.podIP}')
echo "  Pod IP: ${POD_IP}"

echo "  Command: kubectl exec -n ${NAMESPACE} curl-test -- curl -s -k -w '\nHTTP Status: %{http_code}\n' https://${POD_IP}:443"
kubectl exec -n ${NAMESPACE} curl-test -- curl -s -k -w '\nHTTP Status: %{http_code}\n' "https://${POD_IP}:443" || echo "Direct connection failed"

# Then test service name resolution
echo ""
echo "  Command: kubectl exec -n ${NAMESPACE} curl-test -- sh -c \"curl -s -k -w '\nHTTP Status: %{http_code}\n' https://keda-metrics-listener.${NAMESPACE}.svc.cluster.local:443\""
kubectl exec -n ${NAMESPACE} curl-test -- sh -c "curl -s -k -w '\nHTTP Status: %{http_code}\n' https://keda-metrics-listener.${NAMESPACE}.svc.cluster.local:443" || echo "Connection failed"

echo ""
echo "============================================"
echo "Test complete. Press Enter to cleanup..."
read -r
cleanup
