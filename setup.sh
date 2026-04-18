#!/usr/bin/bash
set -e

SOLO_CLUSTER_NAME=solo
SOLO_NAMESPACE=solo
SOLO_DEPLOYMENT=solo-deployment
NODE_IDS=node1
CONSENSUS_NODE_VERSION=v0.71.0
MIRROR_NODE_VERSION=v0.138.0
ENABLE_INGRESS_FLAG=--enable-ingress
HBAR_AMOUNT=10000000

kind create cluster -n ${SOLO_CLUSTER_NAME}

solo init --dev

solo cluster-ref config connect --cluster-ref kind-${SOLO_CLUSTER_NAME} --context kind-${SOLO_CLUSTER_NAME} --dev

solo deployment config create -n ${SOLO_NAMESPACE} --deployment ${SOLO_DEPLOYMENT} --dev

solo deployment cluster attach --deployment ${SOLO_DEPLOYMENT} --cluster-ref kind-${SOLO_CLUSTER_NAME} --num-consensus-nodes 1 --dev

solo keys consensus generate --gossip-keys --tls-keys -i ${NODE_IDS} --deployment ${SOLO_DEPLOYMENT} --dev

solo cluster-ref config setup -s ${SOLO_CLUSTER_NAME} --dev

solo consensus network deploy -i ${NODE_IDS} --deployment ${SOLO_DEPLOYMENT} --release-tag ${CONSENSUS_NODE_VERSION} --dev

solo consensus node setup -i ${NODE_IDS} --deployment ${SOLO_DEPLOYMENT} --release-tag ${CONSENSUS_NODE_VERSION} --quiet-mode --dev

solo consensus node start -i ${NODE_IDS} --deployment ${SOLO_DEPLOYMENT} --dev


kubectl get svc -n ${SOLO_NAMESPACE}

kubectl port-forward svc/haproxy-node1-svc -n ${SOLO_NAMESPACE} 50211:50211 &
kubectl port-forward svc/envoy-proxy-node1-svc -n ${SOLO_NAMESPACE} 9998:8080 &

solo mirror node add --cluster-ref kind-${SOLO_CLUSTER_NAME} --deployment ${SOLO_DEPLOYMENT} --mirror-node-version ${MIRROR_NODE_VERSION} --pinger ${ENABLE_INGRESS_FLAG} --dev --no-parallel-deploy -f helpers/mirror-overrides.yml

kubectl get svc -n ${SOLO_NAMESPACE}

kubectl port-forward svc/mirror-1-rest -n ${SOLO_NAMESPACE} 5551:80 &
kubectl port-forward svc/mirror-1-grpc -n ${SOLO_NAMESPACE} 5600:5600 &
kubectl port-forward svc/mirror-1-web3 -n ${SOLO_NAMESPACE} 8545:80 &
kubectl port-forward svc/mirror-1-restjava -n ${SOLO_NAMESPACE} 8084:80 &

solo relay node add -i ${NODE_IDS} --deployment ${SOLO_DEPLOYMENT} --dev -f helpers/relay-overrides.yml

kubectl get svc -n ${SOLO_NAMESPACE}

rm -rf out
mkdir out

solo ledger account create --generate-ecdsa-key --deployment ${SOLO_DEPLOYMENT} --dev > out/account-output.txt

cat out/account-output.txt

JSON=$(cat out/account-output.txt | python3 helpers/extract_account.py) || {
  echo "Error: Python script failed"
  exit 1
}

export ACCOUNT_ID=$(echo ${JSON} | jq -r '.accountId')
export ACCOUNT_PUBLIC_KEY=$(echo ${JSON} | jq -r '.publicKey')
export ACCOUNT_PRIVATE_KEY=$(kubectl get secret account-key-${ACCOUNT_ID} -n ${SOLO_NAMESPACE} -o jsonpath='{.data.privateKey}' | base64 -d | xargs)

solo ledger account update --account-id "${ACCOUNT_ID}" --hbar-amount "${HBAR_AMOUNT}" --deployment "${SOLO_DEPLOYMENT}" --dev

rm -rf out/solo.txt
touch out/solo.txt

echo "accountId=${ACCOUNT_ID}" >> out/solo.txt
echo "publicKey=${ACCOUNT_PUBLIC_KEY}" >> out/solo.txt
echo "privateKey=${ACCOUNT_PRIVATE_KEY}" >> out/solo.txt

cat out/solo.txt
