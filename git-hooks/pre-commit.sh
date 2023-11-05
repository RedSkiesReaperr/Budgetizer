#!/usr/bin/env bash

echo "Initializing rbenv"
eval "$(rbenv init -)"

echo "Running pre-push hook"

./run-rubocop.sh
if [ $? -ne 0 ]; then
 echo "Rubocop must pass before pushing!"
 exit 1
fi

./run-brakeman.sh
if [ $? -ne 0 ]; then
 echo "Rubocop & Brakeman must pass before pushing!"
 exit 1
fi

./run-specs.sh
if [ $? -ne 0 ]; then
 echo "Rubocop, Brakeman & Specs must pass before pushing!"
 exit 1
fi