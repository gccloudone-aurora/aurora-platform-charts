#!/bin/bash

# Dry-run script for KEDA network policies
# Shows what would be created without actually running kubectl

echo "==================================================="
echo "KEDA Network Policy Dry Run"
echo "==================================================="
echo ""
echo "This shows the network policies that would be created"
echo "for KEDA in the keda-system namespace."
echo ""
echo "Actual deployment requires running on machine with"
echo "kubectl access to the Kubernetes cluster."
echo ""

echo "==================================================="
echo "1. BASE POLICIES (required for all namespaces)"
echo "==================================================="
cat <<EOF
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
EOF

echo ""
echo "==================================================="
echo "2. KEDA METRICS API SERVER POLICIES (CRITICAL)"
echo "==================================================="
echo "# This allows Kubernetes API server to reach KEDA on port 443"
cat <<EOF
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
    # Additional CIDRs for logging/metrics would be added here
  policyTypes:
    - Egress
EOF

echo ""
echo "==================================================="
echo "3. KEDA OPERATOR POLICIES"
echo "==================================================="
cat <<EOF
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
    # Additional CIDRs for logging/metrics would be added here
  policyTypes:
    - Egress
EOF

echo ""
echo "==================================================="
echo "VERIFICATION STEPS (run on machine with kubectl access)"
echo "==================================================="
echo ""
echo "1. Check current KEDA status:"
echo "   kubectl get apiservice v1beta1.external.metrics.k8s.io"
echo ""
echo "2. Check existing network policies:"
echo "   kubectl get netpol -n keda-system"
echo ""
echo "3. Check KEDA pod labels (to verify selectors match):"
echo "   kubectl get pods -n keda-system --show-labels"
echo ""
echo "4. Apply test (optional):"
echo "   chmod +x simple-keda-test.sh"
echo "   ./simple-keda-test.sh"
echo ""
echo "5. Apply actual policies (after verifying):"
echo "   # Save the above YAML to keda-netpol.yaml"
echo "   kubectl apply -f keda-netpol.yaml -n keda-system"
echo ""
echo "6. Monitor APIService status:"
echo "   watch kubectl get apiservice v1beta1.external.metrics.k8s.io"
echo ""
echo "==================================================="
echo "EXPECTED OUTCOME"
echo "==================================================="
echo "After applying network policies:"
echo "- APIService status should change from 'FailedDiscoveryCheck' to 'Available'"
echo "- KEDA metrics API server should be reachable on port 443"
echo "- External metrics should work for HPA"
echo ""
echo "If still failing, check:"
echo "1. Network policy labels match pod labels exactly"
echo "2. Port 443 is correct (check Service definition)"
echo "3. Cilium/network plugin logs for denied connections"
echo "4. Pod security policies or other admission controllers"