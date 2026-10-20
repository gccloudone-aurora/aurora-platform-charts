#!/bin/bash
set -euo pipefail

# Test script for KEDA network policies
# This deploys ONLY the network policies to keda-system namespace
# without installing KEDA itself

CLUSTER_NAME="${1:-nddn}"
NAMESPACE="keda-system"
API_SERVER_CIDR="${2:-10.20.225.11/32}"

# Cleanup function to remove the netpols
cleanup() {
    echo "Cleaning up KEDA network policies..."
    kubectl delete -f /tmp/keda-netpol-values.yaml 2>/dev/null || true
    rm -f /tmp/keda-netpol-values.yaml
    echo "Cleanup complete."
}

# Set trap to cleanup on exit or error
trap cleanup EXIT

# Create the netpol values file
cat > /tmp/keda-netpol-values.yaml <<EOF
resources:
  - apiVersion: networking.k8s.io/v1
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
  - apiVersion: networking.k8s.io/v1
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
EOF

echo "Testing KEDA network policies on cluster: ${CLUSTER_NAME}"
echo "API Server CIDR: ${API_SERVER_CIDR}"
echo ""

echo "Applying network policies to ${NAMESPACE} namespace..."
kubectl apply -f /tmp/keda-netpol-values.yaml

echo ""
echo "Network policies applied. Checking status..."
kubectl get netpol -n ${NAMESPACE}

echo ""
echo "To verify the APIService works after KEDA is installed, run:"
echo "  kubectl get apiregistration.k8s.io v1beta1.external.metrics.k8s.io -o yaml"
echo ""
echo "Netpols will be automatically cleaned up on exit."
