#!/bin/bash

set -x
set -e

helm test -n opal --logs myopal

DATA_URL="http://myopal-opal-client:8181/v1/data"

# Check that users data is present initially
RESULT=$(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/users)
echo "Initial users: $RESULT"
[ "$RESULT" != "{}" ]

# Run the update script
if [ -z $MSYSTEM ]; then
  kubectl exec -n opal service/myopal-opal-server -- /opt/e2e/policy-repo-data/upd.sh
else
  kubectl exec -n opal service/myopal-opal-server -- //opt/e2e/policy-repo-data/upd.sh
fi

sleep 7

# Check that users data is empty after update
RESULT=$(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/users)
echo "After update users: $RESULT"
[ "$RESULT" == "{}" ]

# Check that losers data is present
RESULT=$(kubectl run -n opal curl-test --image=curlimages/curl:latest --rm -i --restart=Never -- curl -s ${DATA_URL}/losers)
echo "Losers data: $RESULT"
[ "$RESULT" != "{}" ]
