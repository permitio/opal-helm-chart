#!/bin/bash

set -x
set -e

if [ -z $MSYSTEM ]; then
  helm upgrade --install --wait --create-namespace -n opal myopal . \
    --set e2e=true --set server.pollingInterval=5 \
    --set server.policyRepoUrl='/opt/e2e/policy-repo.git'
else
  helm upgrade --install --wait --create-namespace -n opal myopal . \
    --set e2e=true --set server.pollingInterval=5 \
    --set server.policyRepoUrl='//opt/e2e/policy-repo.git'
fi

kubectl logs -n opal service/myopal-opal-server git-init
