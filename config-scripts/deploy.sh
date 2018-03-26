#!/bin/bash

# Check if git is installed
if [ -z `command -v git` ]
then
  echo "Git is not installed!"
  exit 1
fi

echo "Install monolith"
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

echo "Starting puma"
puma -d
