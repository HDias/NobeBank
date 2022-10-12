#!/bin/bash

echo 'Starting webpack dev server ...' && ./bin/webpack-dev-server &
echo 'starting Rails server ...' && rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0