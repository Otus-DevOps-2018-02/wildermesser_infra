#!/bin/bash

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

sudo cp /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl daemon-reload
sudo systemctl enable puma
sudo systemctl start puma
