#!/bin/bash

echo "Setting up Git hooks..."

if [ -d .git/hooks ]; then
  rm -rf .git/hooks
fi

ln -s ../hooks .git/hooks

echo "Git hooks have been set up successfully!"
