#!/bin/bash

helm lint . --strict
helm lint . --strict --set server=null
helm lint . --strict --set client=null
helm lint . --strict --set server.broadcastUri=zzz --set server.broadcastPgsql=true
helm lint . --strict --set server.broadcastPgsql=true
helm lint . --strict -f test/linter/values-entries.yaml
