#!/usr/bin/env bash

set -e

cd "${0%/*}/../web"

echo "Running web specs"
yarn test --run