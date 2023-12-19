#!/usr/bin/env bash

echo "Initializing rbenv"
eval "$(rbenv init -)"

echo "Initializing nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "Running pre-push hook"

./git-hooks/run-rubocop.sh
if [ $? -ne 0 ]; then
 echo "Rubocop must pass before pushing!"
 exit 1
fi

./git-hooks/run-brakeman.sh
if [ $? -ne 0 ]; then
 echo "Brakeman must pass before pushing!"
 exit 1
fi

./git-hooks/run-specs.sh
if [ $? -ne 0 ]; then
 echo "RSpecs must pass before pushing!"
 exit 1
fi

./git-hooks/run-web-lint.sh
if [ $? -ne 0 ]; then
 echo "Web lint must pass before pushing!"
 exit 1
fi

./git-hooks/run-web-specs.sh
if [ $? -ne 0 ]; then
 echo "Web specs must pass before pushing!"
 exit 1
fi

./git-hooks/run-web-build.sh
if [ $? -ne 0 ]; then
 echo "Web build must pass before pushing!"
 exit 1
fi
