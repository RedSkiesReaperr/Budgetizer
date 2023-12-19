#!/usr/bin/env bash

set -e

cd "${0%/*}/../web"

echo "Linting web app"
yarn lint --fix