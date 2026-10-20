#!/bin/bash
set -euo pipefail

# Test script for KEDA network policies
# This deploys ONLY the network policies to keda-system namespace
# without installing KEDA itself

CLUSTER_NAME="${1:-nddn}"
NAMESPACE="keda-system"
CLEANUP="${2:-false}"

echo "Testing KEDA network policies on cluster: ${CLUSTER_NAME}"

# Cleanup function to remove the netpols
cleanup() {
    echo "Cleaning up KEDA network policies..."
    kubectl delete -f /tmp/keda-netpol-values.yaml 2>/dev/null || true
    rm -f /tmp/keda-netpol-values.yaml
    echo "Cleanup complete."
}

# If cleanup flag is set, just cleanup and exit
if [ "$CLEANUP" = "true" ]; then
    cleanup
    exit 0
fi

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
                cidr: 0.0.0.0/0
      ports:
        - protocol: TCP
          port: 443
      policyTypes:
        - Egress
  - apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: allow-keda-operator
      namespace: ${NAMESPACE}
    spec:
      podSelector:
        matchLabels:
          app.kubernetes.io/name: keda-operator
      ingress:
        - ports:
            - protocol: TCP
              port: 8080
            - protocol: TCP
              port: 9090
      policyTypes:
        - Ingress
  - apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: allow-keda-operator-egress
      namespace: ${NAMESPACE}
    spec:
      podSelector:
        matchLabels:
          app.kubernetes.io/name: keda-operator
      egress:
        - to:
            - ipBlock:
                cidr: 0.0.0.0/0
      ports:
        - protocol: TCP
          port: 443
      policyTypes:
        - Egress
EOF

echo "Applying network policies to ${NAMESPACE} namespace..."
kubectl apply -f /tmp/keda-netpol-values.yaml

echo "Network policies applied. Checking status..."
kubectl get netpol -n ${NAMESPACE}

echo ""
echo "To verify, run:"
echo "  kubectl get apiregistration.k8s.io v1beta1.external.metrics.k8s.io -o yaml"
echo ""
echo "To cleanup/restore original state after testing, run:"
echo "  ./test-keda-netpol.sh ${CLUSTER_NAME} cleanup"
