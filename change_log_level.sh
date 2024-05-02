#! /bin/bash

set -ux -o pipefail

cat << EOT | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: edit-debug-flags-v
rules:
  # kubeletだけこの権限が必要
- apiGroups:
  - ""
  resources:
  - nodes/proxy
  verbs:
  - update
  # 他のcomponentはこれでOK
- nonResourceURLs:
  - /debug/flags/v
  verbs:
  - put
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: edit-debug-flags-v
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit-debug-flags-v
subjects:
- kind: ServiceAccount
  name: default
  namespace: default
EOT

TOKEN=$(kubectl create token default)
APISERVER=$(kubectl config view --minify --output 'jsonpath={.clusters[0].cluster.server}')

# API Server
curl -s -X PUT -d '5' $APISERVER/debug/flags/v --header "Authorization: Bearer $TOKEN" -k

# Kube proxy
kubectl -n kube-system get configmap kube-proxy -o yaml  | sed -e 's/enableProfiling: false/enableProfiling: true/' | kubectl apply -f -
kubectl -n kube-system rollout restart daemonset/kube-proxy

# Kube scheduler
KUBE_SCHDULER_POD=$(kubectl -n kube-system get pod -l component=kube-scheduler -o jsonpath='{.items[0].metadata.name}')
kubectl -n kube-system port-forward ${KUBE_SCHDULER_POD} 10259:10259 &
PORT_FORWARD_PID=$!
curl -s -X PUT -d '5' https://localhost:10259/debug/flags/v --header "Authorization: Bearer $TOKEN" -k
kill $PORT_FORWARD_PID

vagrant ssh k8s-masternode1 -c "curl -s -X PUT -d '5' https://localhost:10250/debug/flags/v --header \"Authorization: Bearer $TOKEN\" -k"
