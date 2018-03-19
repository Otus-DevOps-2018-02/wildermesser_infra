#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

# Check if ruby and bundler installed
if command -v ruby
then
  echo "Installed:"
  ruby -v
fi

if command -v bundler
then
  echo "Installed:"
  bundler -v
fi
