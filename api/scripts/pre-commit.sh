#!/usr/bin/env bash

echo "Initializing rbenv"
eval "$(rbenv init -)"

echo "Running pre-push hook"
./scripts/run-rubocop.sh
./scripts/run-brakeman.sh
./scripts/run-specs.sh

# $? stores exit value of the last command
if [ $? -ne 0 ]; then
 echo "Rubocop, Brakeman & Specs must pass before pushing!"
 exit 1
fi