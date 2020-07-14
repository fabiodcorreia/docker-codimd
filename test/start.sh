#!/bin/bash

pip install -r ./test/requirements.txt

IP=`ping codimd_test -c 1 -s 16 | grep -o '([^ ]*' | grep -m1 "" | grep -o '([^ ]*' | tr -d '(:)'`

echo "codimd_test = $IP"

APP_TEST_PORT="3000"
APP_TEST_URL="http://$IP:$APP_TEST_PORT"

python ./test/main.py $APP_TEST_URL
