# KEDA Network Policy Verification

## Summary
KEDA requires network policies to allow the Kubernetes API server to reach its metrics API server on port 443. This is implemented in the `aurora-core/templates/keda/netpol.yaml` file.

## Problem
When KEDA is installed in a namespace with strict network policies (like DND cluster), the APIService `v1beta1.external.metrics.k8s.io` shows `FailedDiscoveryCheck` because:
- Kubernetes API server cannot reach KEDA metrics API server on port 443
- Strict network policies block all ingress by default

## Solution
Network policies have been created to:
1. Allow ingress on port 443 to KEDA metrics API server pods
2. Allow DNS egress for service discovery
3. Allow intra-namespace communication within `keda-system`
4. Allow outbound traffic for logging/metrics

## Files Modified
1. `stable/aurora-platform/charts/aurora-core/templates/keda/netpol.yaml` - Main network policy template
2. `test-keda-netpol.sh` - Test script for validation

## How to Test

### Option 1: Manual Test on Target Cluster
```bash
# On the machine with kubectl access to DND cluster:

# 1. First verify kubectl is configured
kubectl config get-contexts
kubectl config use-context <dnd-cluster-context>
kubectl cluster-info

# 2. Check current KEDA status
kubectl get apiservice v1beta1.external.metrics.k8s.io -o wide
kubectl get pods -n keda-system
kubectl get netpol -n keda-system

# 3. Apply the test (if you want to test the pattern)
chmod +x test-keda-netpol.sh
./test-keda-netpol.sh verify  # Check kubectl config
./test-keda-netpol.sh         # Run the test
```

### Option 2: Apply to DND Cluster
Once the changes are merged and deployed via Argo CD:

```bash
# Monitor deployment
kubectl get application -n platform-system | grep keda

# Check if network policies are created
kubectl get netpol -n keda-system

# Expected output:
# NAME                                  POD-SELECTOR                                          AGE
# allow-same-namespace                  <none>                                               1m
# allow-dns                             <none>                                               1m
# allow-keda-metrics-apiserver          app.kubernetes.io/name=keda-operator-metrics-apiserver 1m
# allow-keda-metrics-apiserver-egress   app.kubernetes.io/name=keda-operator-metrics-apiserver 1m
# allow-keda-operator                   app.kubernetes.io/name=keda-operator                  1m
# allow-keda-operator-egress            app.kubernetes.io/name=keda-operator                  1m

# Check APIService status (should change from FailedDiscoveryCheck to Available)
watch kubectl get apiservice v1beta1.external.metrics.k8s.io
```

## Network Policy Details

### 1. `allow-same-namespace`
- Allows pods within `keda-system` to communicate with each other
- Required for KEDA operator to talk to metrics API server

### 2. `allow-dns` 
- Allows DNS queries to `kube-system` namespace
- Required for service discovery and DNS resolution

### 3. `allow-keda-metrics-apiserver`
- **Key policy**: Allows ingress on port 443 to metrics API server pods
- No `from` restriction = allows from anywhere (including Kubernetes API server)
- Uses label selector: `app.kubernetes.io/name: keda-operator-metrics-apiserver`

### 4. `allow-keda-metrics-apiserver-egress`
- Allows metrics API server to send metrics/logs to external endpoints
- Includes logging CIDRs from `global.loggingCidrs`

### 5. `allow-keda-operator`
- Allows management traffic to KEDA operator (ports 8080, 9090)
- For metrics collection and webhooks

### 6. `allow-keda-operator-egress`
- Allows KEDA operator to fetch external metrics from cloud providers
- Includes logging CIDRs from `global.loggingCidrs`

## Validation Steps

After deployment, verify:

1. **APIService status**: Should be `Available` not `FailedDiscoveryCheck`
   ```bash
   kubectl get apiservice v1beta1.external.metrics.k8s.io
   ```

2. **Network policies exist**:
   ```bash
   kubectl get netpol -n keda-system
   ```

3. **Pods can communicate**:
   ```bash
   # Test from a pod in keda-system
   kubectl run test-curl -n keda-system --image=curlimages/curl --rm -it -- \
     curl -v https://keda-metrics-apiserver.keda-system.svc:443
   ```

4. **KEDA functionality**:
   ```bash
   # Check if KEDA can scale deployments
   kubectl get hpa -A
   kubectl describe scaledobject -n <your-namespace>
   ```

## Troubleshooting

If APIService still shows `FailedDiscoveryCheck`:

1. Check network policy labels match KEDA pod labels:
   ```bash
   kubectl get pods -n keda-system --show-labels
   kubectl describe netpol allow-keda-metrics-apiserver -n keda-system
   ```

2. Check if port is correct (should be 443):
   ```bash
   kubectl get service keda-metrics-apiserver -n keda-system -o yaml
   ```

3. Test connectivity manually:
   ```bash
   # Get pod IP
   POD_IP=$(kubectl get pod -n keda-system -l app.kubernetes.io/name=keda-operator-metrics-apiserver -o jsonpath='{.items[0].status.podIP}')
   
   # Test from a pod in default namespace (if allowed)
   kubectl run test-connectivity --image=curlimages/curl --rm -it -- \
     curl -v --connect-timeout 10 "https://${POD_IP}:443"
   ```

4. Check Cilium/network plugin logs:
   ```bash
   kubectl logs -n kube-system -l k8s-app=cilium
   ```

## Notes
- The test script (`test-keda-netpol.sh`) simulates the network policy pattern but runs in a test namespace
- Actual deployment requires Argo CD to sync the Application to the cluster
- Network policies are namespace-scoped, so they only affect `keda-system` namespace
- The `allow-keda-metrics-apiserver` policy allows ingress from **anywhere** on port 443, which is necessary for the Kubernetes API server to reach it