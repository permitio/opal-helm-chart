#!/bin/bash

set -x
set -e

helm test -n opal --logs myopal

DATA_URL='http://localhost:8181/v1/data'

[ $(kubectl exec -n opal service/myopal-client -- curl -s ${DATA_URL}/users) != "{}" ]
if [ -z $MSYSTEM ]; then
  kubectl exec -n opal service/myopal-server -- /opt/e2e/policy-repo-data/upd.sh
else
  kubectl exec -n opal service/myopal-server -- //opt/e2e/policy-repo-data/upd.sh
fi

sleep 7
[ $(kubectl exec -n opal service/myopal-client -- curl -s ${DATA_URL}/users) == "{}" ]
[ $(kubectl exec -n opal service/myopal-client -- curl -s ${DATA_URL}/losers) != "{}" ]
