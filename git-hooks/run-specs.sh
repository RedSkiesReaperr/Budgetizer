#!/usr/bin/env bash

set -e

cd "${0%/*}/../api"

echo "Running tests"
bundle exec rspec