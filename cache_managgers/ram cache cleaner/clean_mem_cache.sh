#!/bin/bash

# Clear memory cache
sudo sync; echo 1 > /proc/sys/vm/drop_caches

# Clear disk cache
sudo sync; echo 3 > /proc/sys/vm/drop_caches


# Clear package manager cache (apt)
sudo apt-get clean

# Clear thumbnail cache
rm -rf ~/.cache/thumbnails/*

echo "Caches cleared successfully."