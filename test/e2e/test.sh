#!/bin/bash

set -x
set -e

helm test -n opal --logs myopal

DATA_URL="http://myopal-opal-client:8181/v1/data"

[ $(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/users) != "{}" ]
if [ -z $MSYSTEM ]; then
  kubectl exec -n opal service/myopal-opal-server -- /opt/e2e/policy-repo-data/upd.sh
else
  kubectl exec -n opal service/myopal-opal-server -- //opt/e2e/policy-repo-data/upd.sh
fi

sleep 7
[ $(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/users) == "{}" ]
[ $(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/losers) != "{}" ]
