#!/bin/bash

apt update && apt install curl wget unzip

wget https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
chmod +x install-release.sh
sudo ./install-release.sh
