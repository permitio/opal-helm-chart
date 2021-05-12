#!/bin/sh

cd /opt/e2e/policy-repo-working

sed -i 's/users/losers/g' data.json

git commit -am 'chore: update'
git push
