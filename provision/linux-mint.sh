#!/bin/bash

# Third party PPA
sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

# Update packages
sudo apt-get update

# Description: Provisioning script for Linux Mint
sudo apt-get install -y xsel

# Install heroku CLI
sudo apt-get install heroku

