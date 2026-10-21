#!/bin/bash
set -euo pipefail

# Apply KEDA network policies to keda-system namespace
# Run this on the machine with kubectl access to the cluster

echo "=========================================="
echo "Applying KEDA Network Policies"
echo "=========================================="
echo ""

# Check if we're in the right namespace
CURRENT_NS=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || echo "default")
echo "Current namespace context: ${CURRENT_NS}"
echo "Target namespace: keda-system"
echo ""

# Create network policies
echo "Creating KEDA network policies in keda-system namespace..."
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: keda-system
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
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
  namespace: keda-system
spec:
  podSelector: {}
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
  policyTypes:
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-metrics-apiserver
  namespace: keda-system
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
  namespace: keda-system
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: keda-operator-metrics-apiserver
  egress:
    - to:
        - ipBlock:
            cidr: 0.0.0.0/0
  policyTypes:
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-operator
  namespace: keda-system
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
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-keda-operator-egress
  namespace: keda-system
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: keda-operator
  egress:
    - to:
        - ipBlock:
            cidr: 0.0.0.0/0
  policyTypes:
    - Egress
EOF

echo ""
echo "=========================================="
echo "Verification"
echo "=========================================="
echo ""
echo "1. Check network policies were created:"
kubectl get netpol -n keda-system
echo ""
echo "2. Check KEDA APIService status:"
kubectl get apiservice v1beta1.external.metrics.k8s.io
echo ""
echo "3. Check KEDA pods:"
kubectl get pods -n keda-system
echo ""
echo "4. Verify pod labels match network policy selectors:"
kubectl get pods -n keda-system --show-labels | head -5
echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo ""
echo "If APIService still shows 'FailedDiscoveryCheck':"
echo "1. Wait 1-2 minutes for changes to propagate"
echo "2. Check Cilium/network plugin logs:"
echo "   kubectl logs -n kube-system -l k8s-app=cilium | tail -20"
echo "3. Test connectivity manually:"
echo "   kubectl run test-curl -n keda-system --image=curlimages/curl --rm -it -- \\"
echo "     curl -v https://keda-metrics-apiserver.keda-system.svc:443"
echo ""
echo "To remove policies:"
echo "   kubectl delete netpol --all -n keda-system"
echo ""
echo "Note: These are temporary manual fixes."
echo "For production, use the Argo CD Application in:"
echo "   stable/aurora-platform/charts/aurora-core/templates/keda/netpol.yaml"